import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showingHistory = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                Form {
                    Section(header: Text("Основные параметры")) {
                        HStack {
                            Text("Скорость: \(Int(viewModel.speed)) км/ч")
                            Slider(value: $viewModel.speed, in: 10...200, step: 5)
                        }
                        
                        Picker("Дорожное покрытие", selection: $viewModel.roadType) {
                            ForEach(RoadType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        
                        Picker("Погода", selection: $viewModel.weather) {
                            ForEach(WeatherCondition.allCases) { condition in
                                Text(condition.rawValue).tag(condition)
                            }
                        }
                        
                        Picker("Состояние дороги", selection: $viewModel.roadCondition) {
                            ForEach(RoadCondition.allCases) { condition in
                                Text(condition.rawValue).tag(condition)
                            }
                        }
                    }
                    
                    Section(header: Text("Автомобиль")) {
                        Picker("Тип резины", selection: $viewModel.tireType) {
                            ForEach(TireType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        
                        if viewModel.tireType == .winter {
                            Toggle("Шипованная резина", isOn: $viewModel.hasSpikes)
                        }
                        
                        Picker("Система торможения", selection: $viewModel.absStatus) {
                            ForEach(ABSStatus.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        
                        Picker("Состояние тормозов", selection: $viewModel.brakeCondition) {
                            ForEach(BrakeCondition.allCases) { condition in
                                Text(condition.rawValue).tag(condition)
                            }
                        }
                        
                        Picker("Загрузка автомобиля", selection: $viewModel.vehicleLoad) {
                            ForEach(VehicleLoad.allCases) { load in
                                Text(load.rawValue).tag(load)
                            }
                        }
                        
                        Toggle("Спойлер (+5% сцепления)", isOn: $viewModel.hasSpoiler)
                    }
                    
                    Section(header: Text("Дополнительные параметры")) {
                        Picker("Уклон дороги", selection: $viewModel.roadSlope) {
                            ForEach(RoadSlope.allCases) { slope in
                                Text(slope.rawValue).tag(slope)
                            }
                        }
                        
                        Picker("Давление в шинах", selection: $viewModel.tirePressure) {
                            ForEach(TirePressure.allCases) { pressure in
                                Text(pressure.rawValue).tag(pressure)
                            }
                        }
                        
                        HStack {
                            Text("Глубина протектора: \(viewModel.treadDepth, specifier: "%.1f") мм")
                            Slider(value: $viewModel.treadDepth, in: 1...10, step: 0.5)
                        }
                        
                        HStack {
                            Text("Температура: \(Int(viewModel.temperature))°C")
                            Slider(value: $viewModel.temperature, in: -30...50, step: 1)
                        }
                        
                        HStack {
                            Text("Влажность дороги: \(Int(viewModel.surfaceMoisture))%")
                            Slider(value: $viewModel.surfaceMoisture, in: 0...100, step: 1)
                        }
                    }
                    
                    Section(header: Text("Системы безопасности")) {
                        Toggle("EBD (распределение тормозов)", isOn: $viewModel.hasEBD)
                        Toggle("BA (помощь при торможении)", isOn: $viewModel.hasBA)
                        Toggle("ESP (курсовая устойчивость)", isOn: $viewModel.hasESP)
                    }
                    
                    Section(header: Text("Результаты")) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Тормозной путь: \(viewModel.brakingDistance, specifier: "%.1f") метров")
                                .font(.headline)
                            
                            Text("Коэффициент трения: \(viewModel.adjustedFriction, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Text("Эффективность:")
                                Spacer()
                                EfficiencyBar(value: viewModel.brakingDistance / (pow(viewModel.speed/3.6, 2)/(2*0.7*9.81)))
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Section {
                        Button(action: viewModel.startAnimation) {
                            HStack {
                                Image(systemName: "car.fill")
                                Text(viewModel.buttonText)
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.animationPhase == .ready ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(viewModel.animationPhase != .ready)
                    }
                    
                    Section(header: Text("Анимация торможения")) {
                        ZStack(alignment: .leading) {
                            RoadView(length: viewModel.totalRoadLength)
                                .offset(x: viewModel.roadOffset)
                            
                            if viewModel.animationPhase == .braking {
                                BrakingZoneView(width: viewModel.displayBrakingDistance)
                                    .offset(x: UIScreen.main.bounds.width / 2 - 30)
                            }
                            
                            CarView(tireType: viewModel.tireType)
                                .offset(x: viewModel.carPosition)
                                .animation(
                                    viewModel.animationPhase == .accelerating ? .easeIn(duration: 1) :
                                    viewModel.animationPhase == .cruising ? .linear(duration: viewModel.cruisingDuration) :
                                    viewModel.animationPhase == .braking ? .easeOut(duration: viewModel.brakingDuration) : nil,
                                    value: viewModel.carPosition
                                )
                        }
                        .frame(height: 120)
                        .padding(.vertical)
                    }
                    
                    Section {
                        Button("Сохранить результат") {
                            viewModel.saveCalculation()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .navigationTitle("Тормозной путь")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("История") {
                            showingHistory.toggle()
                        }
                    }
                }
                .sheet(isPresented: $showingHistory) {
                    HistoryView(viewModel: HistoryViewModel(history: viewModel.calculationHistory))
                }
            }
            .tabItem {
                Image(systemName: "car.fill")
                Text("Симуляция")
            }
            .tag(0)
            
            GuideView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Справочник")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Настройки")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
