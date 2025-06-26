import SwiftUI

struct ContentView: View {
    @StateObject private var calculationVM = CalculationViewModel()
    @StateObject private var animationVM = AnimationViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                SimulationView(calculationVM: calculationVM, animationVM: animationVM)
                    .onAppear {
                        animationVM.reset()
                    }
                    .onDisappear {
                        animationVM.stopAnimation()
                    }
            }
            .tag(0)
            .tabItem {
                Image(systemName: "car.fill")
                Text("Симуляция")
            }
            
            HistoryView(viewModel: HistoryViewModel(history: calculationVM.calculationHistory))
                .tag(1)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("История")
                }
            
            SettingsView()
                .tag(2)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Настройки")
                }
        }
        .onChange(of: selectedTab) { newValue in
            if newValue != 0 {
                animationVM.stopAnimation()
            }
        }
    }
}

struct SimulationView: View {
    @ObservedObject var calculationVM: CalculationViewModel
    @ObservedObject var animationVM: AnimationViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Основные параметры")) {
                HStack {
                    Text("Скорость: \(Int(calculationVM.speed)) км/ч")
                    Slider(value: $calculationVM.speed, in: 10...200, step: 5)
                        .onChange(of: calculationVM.speed) { _ in
                            calculationVM.clearCache()
                        }
                }
                
                Picker("Дорожное покрытие", selection: $calculationVM.roadType) {
                    ForEach(RoadType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .onChange(of: calculationVM.roadType) { _ in
                    calculationVM.clearCache()
                }
                
                Picker("Погода", selection: $calculationVM.weather) {
                    ForEach(WeatherCondition.allCases) { condition in
                        Text(condition.rawValue).tag(condition)
                    }
                }
                .onChange(of: calculationVM.weather) { _ in
                    calculationVM.clearCache()
                }
                
                Picker("Состояние дороги", selection: $calculationVM.roadCondition) {
                    ForEach(RoadCondition.allCases) { condition in
                        Text(condition.rawValue).tag(condition)
                    }
                }
                .onChange(of: calculationVM.roadCondition) { _ in
                    calculationVM.clearCache()
                }
            }
            
            Section(header: Text("Автомобиль")) {
                Picker("Тип резины", selection: $calculationVM.tireType) {
                    ForEach(TireType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .onChange(of: calculationVM.tireType) { _ in
                    calculationVM.clearCache()
                }
                
                if calculationVM.tireType == .winter {
                    Toggle("Шипованная резина", isOn: $calculationVM.hasSpikes)
                        .onChange(of: calculationVM.hasSpikes) { _ in
                            calculationVM.clearCache()
                        }
                }
                
                Picker("Система торможения", selection: $calculationVM.absStatus) {
                    ForEach(ABSStatus.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .onChange(of: calculationVM.absStatus) { _ in
                    calculationVM.clearCache()
                }
                
                Picker("Состояние тормозов", selection: $calculationVM.brakeCondition) {
                    ForEach(BrakeCondition.allCases) { condition in
                        Text(condition.rawValue).tag(condition)
                    }
                }
                .onChange(of: calculationVM.brakeCondition) { _ in
                    calculationVM.clearCache()
                }
                
                Picker("Загрузка автомобиля", selection: $calculationVM.vehicleLoad) {
                    ForEach(VehicleLoad.allCases) { load in
                        Text(load.rawValue).tag(load)
                    }
                }
                .onChange(of: calculationVM.vehicleLoad) { _ in
                    calculationVM.clearCache()
                }
                
                Toggle("Спойлер (+5% сцепления)", isOn: $calculationVM.hasSpoiler)
                    .onChange(of: calculationVM.hasSpoiler) { _ in
                        calculationVM.clearCache()
                    }
            }
            
            Section(header: Text("Дополнительные параметры")) {
                Picker("Уклон дороги", selection: $calculationVM.roadSlope) {
                    ForEach(RoadSlope.allCases) { slope in
                        Text(slope.rawValue).tag(slope)
                    }
                }
                .onChange(of: calculationVM.roadSlope) { _ in
                    calculationVM.clearCache()
                }
                
                Picker("Давление в шинах", selection: $calculationVM.tirePressure) {
                    ForEach(TirePressure.allCases) { pressure in
                        Text(pressure.rawValue).tag(pressure)
                    }
                }
                .onChange(of: calculationVM.tirePressure) { _ in
                    calculationVM.clearCache()
                }
                
                HStack {
                    Text("Глубина протектора: \(calculationVM.treadDepth, specifier: "%.1f") мм")
                    Slider(value: $calculationVM.treadDepth, in: 1...10, step: 0.5)
                        .onChange(of: calculationVM.treadDepth) { _ in
                            calculationVM.clearCache()
                        }
                }
                
                HStack {
                    Text("Температура: \(Int(calculationVM.temperature))°C")
                    Slider(value: $calculationVM.temperature, in: -30...50, step: 1)
                        .onChange(of: calculationVM.temperature) { _ in
                            calculationVM.clearCache()
                        }
                }
                
                HStack {
                    Text("Влажность дороги: \(Int(calculationVM.surfaceMoisture))%")
                    Slider(value: $calculationVM.surfaceMoisture, in: 0...100, step: 1)
                        .onChange(of: calculationVM.surfaceMoisture) { _ in
                            calculationVM.clearCache()
                        }
                }
            }
            
            Section(header: Text("Системы безопасности")) {
                Toggle("EBD (распределение тормозов)", isOn: $calculationVM.hasEBD)
                    .onChange(of: calculationVM.hasEBD) { _ in
                        calculationVM.clearCache()
                    }
                Toggle("BA (помощь при торможении)", isOn: $calculationVM.hasBA)
                    .onChange(of: calculationVM.hasBA) { _ in
                        calculationVM.clearCache()
                    }
                Toggle("ESP (курсовая устойчивость)", isOn: $calculationVM.hasESP)
                    .onChange(of: calculationVM.hasESP) { _ in
                        calculationVM.clearCache()
                    }
            }
            
            Section(header: Text("Результаты")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Тормозной путь: \(calculationVM.brakingDistance, specifier: "%.1f") метров")
                        .font(.headline)
                    
                    Text("Коэффициент трения: \(calculationVM.adjustedFriction, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Эффективность:")
                        Spacer()
                        EfficiencyBar(value: calculationVM.brakingDistance / (pow(calculationVM.speed/3.6, 2)/(2*0.7*9.81)))
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section {
                Button(action: {
                    animationVM.startAnimation(calculationVM: calculationVM)
                }) {
                    HStack {
                        Image(systemName: "car.fill")
                        Text(animationVM.buttonText)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(animationVM.animationPhase == .ready ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(animationVM.animationPhase != .ready)
            }
            
            Section(header: Text("Анимация торможения")) {
                ZStack(alignment: .leading) {
                    RoadView(length: animationVM.totalRoadLength(for: calculationVM.brakingDistance))
                        .offset(x: animationVM.roadOffset)
                    
                    if animationVM.animationPhase == .braking {
                        BrakingZoneView(width: animationVM.displayBrakingDistance(for: calculationVM.brakingDistance))
                            .offset(x: UIScreen.main.bounds.width / 2 - 30)
                    }
                    
                    CarView(tireType: calculationVM.tireType)
                        .offset(x: animationVM.carPosition)
                        .drawingGroup() // Ускорение рендеринга
                }
                .frame(height: 120)
                .padding(.vertical)
            }
            
            Section {
                Button("Сохранить результат") {
                    calculationVM.saveCalculation()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Тормозной путь")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("История") {
                    HistoryView(viewModel: HistoryViewModel(history: calculationVM.calculationHistory))
                }
            }
        }
    }
}
