import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var viewModel: SettingsViewModel
    
    init() {
        // Используем временные настройки для инициализации
        let tempSettings = AppSettings()
        _viewModel = StateObject(wrappedValue: SettingsViewModel(settings: tempSettings))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Режим работы")) {
                    Toggle("Расширенный режим", isOn: $viewModel.isAdvancedMode)
                    Picker("Система измерений", selection: $viewModel.unitSystem) {
                        Text("Метрическая (км/ч)").tag(0)
                        Text("Имперская (мили/ч)").tag(1)
                    }
                }
                
                Section(header: Text("Настройки по умолчанию")) {
                    HStack {
                        Text("Скорость: \(Int(viewModel.defaultSpeed)) км/ч")
                        Slider(value: $viewModel.defaultSpeed, in: 30...120, step: 5)
                    }
                    
                    Picker("Покрытие", selection: $viewModel.defaultRoadType) {
                        ForEach(RoadType.allCases) { type in
                            Text(type.rawValue).tag(type.rawValue)
                        }
                    }
                }
                
                Section(header: Text("О приложении")) {
                    HStack {
                        Text("Версия")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link("Связаться с поддержкой", destination: URL(string: "https://t.me/metelykx")!)
                }
            }
            .navigationTitle("Настройки")
            .onAppear {
                // Обновляем ViewModel реальными настройками при появлении
                viewModel.updateSettings(from: appSettings)
            }
            .onDisappear {
                // Сохраняем настройки при закрытии
                viewModel.saveSettings(to: appSettings)
            }
        }
    }
}
