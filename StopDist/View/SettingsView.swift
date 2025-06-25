//
//  SettingsView.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 25.06.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var viewModel: SettingsViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(settings: AppSettings()))
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
                    
                    Link("Политика конфиденциальности", destination: URL(string: "https://example.com/privacy")!)
                    Link("Связаться с поддержкой", destination: URL(string: "https://example.com/support")!)
                }
            }
            .navigationTitle("Настройки")
            .onDisappear {
                viewModel.saveSettings(to: appSettings)
            }
        }
    }
}
