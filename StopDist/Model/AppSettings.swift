//
//  AppSettings.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 25.06.2025.
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("isAdvancedMode") var isAdvancedMode = false
    @AppStorage("defaultSpeed") var defaultSpeed = 60.0
    @AppStorage("defaultRoadType") var defaultRoadType = RoadType.asphalt.rawValue
    @AppStorage("unitSystem") var unitSystem = 0
}
