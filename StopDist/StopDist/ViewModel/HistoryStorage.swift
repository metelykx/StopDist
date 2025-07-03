//
//  HistoryStorage.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 03.07.2025.
//

import Foundation

class HistoryStorage: ObservableObject {
    static let shared = HistoryStorage()
    private let storageKey = "CalculationHistory"
    
    @Published var history: [Calculation] = [] {
        didSet {
            saveHistory()
        }
    }
    
    private init() {
        loadHistory()
    }
    
    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Calculation].self, from: data) else { return }
        history = decoded
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func add(_ calculation: Calculation) {
        history.insert(calculation, at: 0)
    }
    
    func delete(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)
    }
    
    func clear() {
        history.removeAll()
    }
}
