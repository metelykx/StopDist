//
//  Calculation.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 25.06.2025.
//

import Foundation
import SwiftUI

struct Calculation: Identifiable {
    let id = UUID()
    let speed: Double
    let roadType: String
    let weather: String
    let roadCondition: String
    let tireType: String
    let hasSpikes: Bool
    let absStatus: String
    let brakeCondition: String
    let vehicleLoad: String
    let distance: Double
    let date: Date
}
