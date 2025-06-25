//
//  ContentViewModel.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 25.06.2025.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    // Основные параметры
    @Published var speed: Double = 60
    @Published var roadType: RoadType = .asphalt
    @Published var weather: WeatherCondition = .dry
    @Published var roadCondition: RoadCondition = .normal
    @Published var hasSpoiler: Bool = false
    
    // Резина и тормоза
    @Published var tireType: TireType = .summer
    @Published var hasSpikes: Bool = false
    @Published var absStatus: ABSStatus = .withABS
    @Published var brakeCondition: BrakeCondition = .new
    
    // Состояние автомобиля
    @Published var vehicleLoad: VehicleLoad = .medium
    @Published var roadSlope: RoadSlope = .flat
    @Published var tirePressure: TirePressure = .optimal
    @Published var treadDepth: Double = 8.0
    
    // Системы безопасности
    @Published var hasEBD: Bool = true
    @Published var hasBA: Bool = true
    @Published var hasESP: Bool = true
    
    // Температура и влажность
    @Published var temperature: Double = 20.0
    @Published var surfaceMoisture: Double = 30.0
    
    // История расчетов
    @Published var calculationHistory: [Calculation] = []
    
    // Фазы анимации
    enum AnimationPhase {
        case ready, accelerating, cruising, braking, stopped
    }
    @Published var animationPhase: AnimationPhase = .ready
    @Published var carPosition: CGFloat = 0
    @Published var roadOffset: CGFloat = 0
    
    var buttonText: String {
        switch animationPhase {
        case .ready: return "Запустить симуляцию"
        case .accelerating: return "Разгон..."
        case .cruising: return "Движение..."
        case .braking: return "Торможение..."
        case .stopped: return "Завершено"
        }
    }
    
    var displayBrakingDistance: CGFloat {
        min(CGFloat(brakingDistance) * 5, UIScreen.main.bounds.width * 2)
    }
    
    var totalRoadLength: CGFloat {
        UIScreen.main.bounds.width + displayBrakingDistance + 100
    }
    
    var cruisingDuration: Double { Double(300 / speed) }
    var brakingDuration: Double { Double(brakingDistance) * 0.02 }
    
    var adjustedFriction: Double {
        let baseFriction: Double = {
            switch roadType {
            case .asphalt: return 0.7
            case .snow: return 0.3
            case .sand: return 0.4
            case .ice: return 0.15
            case .gravel: return 0.45
            }
        }()
        
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
            switch tireType {
            case .summer:
                return (roadType == .snow || roadType == .ice) ? 0.6 : 1.0
            case .winter:
                var multiplier = 1.2
                if hasSpikes {
                    multiplier *= (roadType == .ice) ? 1.4 : 1.1
                }
                return multiplier
            }
        }()
        
        let spoilerMultiplier = hasSpoiler ? 1.05 : 1.0
        let temperatureFactor = 1.0 - abs(temperature - 20) * 0.005
        let moistureFactor = 1.0 - surfaceMoisture * 0.002
        
        return baseFriction * weatherMultiplier * roadConditionMultiplier *
               tireMultiplier * spoilerMultiplier * temperatureFactor * moistureFactor
    }
    
    var brakingDistance: Double {
        let speedInMetersPerSecond = speed / 3.6
        var baseDistance = pow(speedInMetersPerSecond, 2) / (2 * adjustedFriction * 9.81)
        
        switch absStatus {
        case .withABS:
            baseDistance *= 0.85
        case .withoutABS:
            if roadType == .ice || roadCondition == .icy {
                baseDistance *= 1.2
            }
        }
        
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
            switch treadDepth {
            case 8.0...: return 1.0
            case 6.0..<8.0: return 0.95
            case 4.0..<6.0: return 0.85
            case 2.0..<4.0: return 0.7
            default: return 0.6
            }
        }()
        
        return baseDistance * loadFactor * slopeFactor * pressureFactor *
               brakeEfficiency * safetyFactor * treadFactor
    }
    
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
        calculationHistory.insert(newCalc, at: 0)
    }
    
    func startAnimation() {
        animationPhase = .accelerating
        carPosition = -UIScreen.main.bounds.width / 2 + 50
        roadOffset = 0
        
        withAnimation(.easeIn(duration: 1)) {
            carPosition = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animationPhase = .cruising
            withAnimation(.linear(duration: self.cruisingDuration)) {
                self.carPosition = UIScreen.main.bounds.width / 2 - 30
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.cruisingDuration) {
                self.animationPhase = .braking
                withAnimation(.easeOut(duration: self.brakingDuration)) {
                    self.carPosition += self.displayBrakingDistance
                    self.roadOffset = -self.displayBrakingDistance
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + self.brakingDuration) {
                    self.animationPhase = .stopped
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.animationPhase = .ready
                    }
                }
            }
        }
    }
}
