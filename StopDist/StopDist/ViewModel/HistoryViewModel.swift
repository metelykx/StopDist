import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    private let storage = HistoryStorage.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var history: [Calculation] = []
    
    init() {
        storage.$history
            .receive(on: RunLoop.main)
            .assign(to: \.history, on: self)
            .store(in: &cancellables)
    }
    
    func deleteItems(at offsets: IndexSet) {
        storage.delete(at: offsets)
    }
    
    func clearHistory() {
        storage.clear()
    }
}
