import Foundation

protocol CalculatorRepositoryProtocol {
    func save(historyEntry: String)
    func fetchHistory() -> [String]
    func clearHistory()
}
