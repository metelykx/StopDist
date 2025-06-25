//
//  SettingsViewModel.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 25.06.2025.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var isAdvancedMode: Bool
    @Published var defaultSpeed: Double
    @Published var defaultRoadType: String
    @Published var unitSystem: Int
    
    init(settings: AppSettings) {
        self.isAdvancedMode = settings.isAdvancedMode
        self.defaultSpeed = settings.defaultSpeed
        self.defaultRoadType = settings.defaultRoadType
        self.unitSystem = settings.unitSystem
    }
    
    func saveSettings(to settings: AppSettings) {
        settings.isAdvancedMode = isAdvancedMode
        settings.defaultSpeed = defaultSpeed
        settings.defaultRoadType = defaultRoadType
        settings.unitSystem = unitSystem
    }
}
