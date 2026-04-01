import Foundation

final class InMemoryCalculatorRepository: CalculatorRepositoryProtocol {
    private var history: [String] = []
    private let queue = DispatchQueue(label: "InMemoryCalculatorRepository.queue", attributes: .concurrent)

    func save(historyEntry: String) {
        queue.async(flags: .barrier) {
            self.history.append(historyEntry)
        }
    }

    func fetchHistory() -> [String] {
        var result: [String] = []
        queue.sync {
            result = self.history
        }
        return result
    }

    func clearHistory() {
        queue.async(flags: .barrier) {
            self.history.removeAll()
        }
    }
}
