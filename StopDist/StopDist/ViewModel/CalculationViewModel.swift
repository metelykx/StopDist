import SwiftUI

class CalculationViewModel: ObservableObject {
    // MARK: - Параметры автомобиля
    @Published var speed: Double = 60
    @Published var roadType: RoadType = .asphalt
    @Published var weather: WeatherCondition = .dry
    @Published var roadCondition: RoadCondition = .normal
    @Published var hasSpoiler: Bool = false
    
    // MARK: - Параметры резины и тормозов
    @Published var tireType: TireType = .summer
    @Published var hasSpikes: Bool = false
    @Published var absStatus: ABSStatus = .withABS
    @Published var brakeCondition: BrakeCondition = .new
    
    // MARK: - Состояние автомобиля
    @Published var vehicleLoad: VehicleLoad = .medium
    @Published var roadSlope: RoadSlope = .flat
    @Published var tirePressure: TirePressure = .optimal
    @Published var treadDepth: Double = 8.0
    
    // MARK: - Системы безопасности
    @Published var hasEBD: Bool = true
    @Published var hasBA: Bool = true
    @Published var hasESP: Bool = true
    
    // MARK: - Параметры окружающей среды
    @Published var temperature: Double = 20.0
    @Published var surfaceMoisture: Double = 30.0
    
    // MARK: - История расчетов
    private let storage = HistoryStorage.shared
    
    var calculationHistory: [Calculation] {
        storage.history
    }
    
    // MARK: - Кеши для оптимизации
    private var frictionCache: Double?
    private var distanceCache: Double?
    
    // MARK: - Вычисляемые свойства
    var adjustedFriction: Double {
        if let cached = frictionCache { return cached }
        
        // Базовый коэффициент трения
        let baseFriction: Double = {
            switch roadType {
            case .asphalt: return 0.7
            case .snow: return 0.3
            case .sand: return 0.4
            case .ice: return 0.15
            case .gravel: return 0.45
            }
        }()
        
        // Модификаторы условий
        let weatherMultiplier: Double = {
            switch weather {
            case .dry: return 1.0
            case .rain: return 0.8
            case .snow: return 0.6
            case .fog: return 0.95
            }
        }()
        
        let roadConditionMultiplier: Double = {
            switch roadCondition {
            case .normal: return 1.0
            case .wet: return 0.85
            case .icy: return 0.65
            }
        }()
        
        let tireMultiplier: Double = {
            if tireType == .summer {
                return (roadType == .snow || roadType == .ice) ? 0.6 : 1.0
            } else {
                return hasSpikes ? (roadType == .ice ? 1.54 : 1.32) : 1.2
            }
        }()
        
        // Дополнительные факторы
        let spoilerMultiplier = hasSpoiler ? 1.05 : 1.0
        let temperatureFactor = 1.0 - abs(temperature - 20) * 0.005
        let moistureFactor = 1.0 - surfaceMoisture * 0.002
        
        // Итоговый коэффициент трения
        let result = baseFriction * weatherMultiplier * roadConditionMultiplier *
               tireMultiplier * spoilerMultiplier * temperatureFactor * moistureFactor
        
        frictionCache = result
        return result
    }
    
    var brakingDistance: Double {
        if let cached = distanceCache { return cached }
        
        // Базовый расчет дистанции
        let speedInMetersPerSecond = speed / 3.6
        var baseDistance = pow(speedInMetersPerSecond, 2) / (2 * adjustedFriction * 9.81)
        
        // Влияние ABS
        switch absStatus {
        case .withABS:
            baseDistance *= 0.85
        case .withoutABS:
            if roadType == .ice || roadCondition == .icy {
                baseDistance *= 1.2
            }
        }
        
        // Дополнительные факторы
        let loadFactor: Double = {
            switch vehicleLoad {
            case .empty: return 1.0
            case .medium: return 1.15
            case .full: return 1.3
            }
        }()
        
        let slopeFactor: Double = {
            switch roadSlope {
            case .uphill: return 0.9
            case .flat: return 1.0
            case .downhill: return 1.15
            }
        }()
        
        let pressureFactor: Double = {
            switch tirePressure {
            case .optimal: return 1.0
            case .low: return 0.9
            case .high: return 0.95
            }
        }()
        
        let brakeEfficiency: Double = {
            switch brakeCondition {
            case .new: return 1.0
            case .worn: return 0.9
            case .poor: return 0.75
            }
        }()
        
        let safetyFactor: Double = {
            var factor = 1.0
            if hasEBD { factor *= 0.95 }
            if hasBA { factor *= 0.92 }
            if hasESP { factor *= 0.97 }
            return factor
        }()
        
        let treadFactor: Double = {
            if treadDepth >= 8.0 { return 1.0 }
            else if treadDepth >= 6.0 { return 0.95 }
            else if treadDepth >= 4.0 { return 0.85 }
            else if treadDepth >= 2.0 { return 0.7 }
            else { return 0.6 }
        }()
        
        // Итоговая дистанция торможения
        let result = baseDistance * loadFactor * slopeFactor * pressureFactor *
               brakeEfficiency * safetyFactor * treadFactor
        
        distanceCache = result
        return result
    }
    
    // MARK: - Действия
    func saveCalculation() {
        let newCalc = Calculation(
            speed: speed,
            roadType: roadType.rawValue,
            weather: weather.rawValue,
            roadCondition: roadCondition.rawValue,
            tireType: tireType.rawValue,
            hasSpikes: hasSpikes,
            absStatus: absStatus.rawValue,
            brakeCondition: brakeCondition.rawValue,
            vehicleLoad: vehicleLoad.rawValue,
            distance: brakingDistance,
            date: Date()
        )
        storage.add(newCalc)
    }
    
    func clearCache() {
        frictionCache = nil
        distanceCache = nil
    }
}


