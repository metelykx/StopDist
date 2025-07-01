//
//  HistoryViewModel.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 25.06.2025.
//

import Foundation

class HistoryViewModel: ObservableObject {
    @Published var history: [Calculation]
    
    init(history: [Calculation]) {
        self.history = history
    }
    
    func deleteItems(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)
    }
    
    func clearHistory() {
        history.removeAll()
    }
}
