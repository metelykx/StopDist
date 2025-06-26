//
//  RoadModel.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 25.06.2025.
//

import SwiftUI
import Foundation

enum RoadType: String, CaseIterable, Identifiable {
    case asphalt = "Асфальт"
    case snow = "Снег"
    case sand = "Песок"
    case ice = "Лед"
    case gravel = "Гравий"
    var id: String { self.rawValue }
}

enum WeatherCondition: String, CaseIterable, Identifiable {
    case dry = "Сухо"
    case rain = "Дождь"
    case snow = "Снегопад"
    case fog = "Туман"
    var id: String { self.rawValue }
}

enum TireType: String, CaseIterable, Identifiable {
    case summer = "Летняя"
    case winter = "Зимняя"
    var id: String { self.rawValue }
}

enum ABSStatus: String, CaseIterable, Identifiable {
    case withABS = "С ABS"
    case withoutABS = "Без ABS"
    var id: String { self.rawValue }
}

enum RoadCondition: String, CaseIterable, Identifiable {
    case normal = "Нормальное"
    case wet = "Мокрое"
    case icy = "Обледенелое"
    var id: String { self.rawValue }
}

enum BrakeCondition: String, CaseIterable, Identifiable {
    case new = "Новые"
    case worn = "Изношенные"
    case poor = "Плохие"
    var id: String { self.rawValue }
}

enum VehicleLoad: String, CaseIterable, Identifiable {
    case empty = "Пустой"
    case medium = "Средняя"
    case full = "Полная"
    var id: String { self.rawValue }
}

enum RoadSlope: String, CaseIterable, Identifiable {
    case uphill = "Подъем"
    case flat = "Ровная"
    case downhill = "Спуск"
    var id: String { self.rawValue }
}

enum TirePressure: String, CaseIterable, Identifiable {
    case optimal = "Оптимальное"
    case low = "Низкое"
    case high = "Высокое"
    var id: String { self.rawValue }
}
