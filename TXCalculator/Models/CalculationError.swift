import Foundation

enum CalculationError: Error, CustomStringConvertible {
    case divideByZero
    case overflow
    case invalidInput(String)
    case parseError(String)

    var description: String {
        switch self {
        case .divideByZero:
            return "Cannot divide by zero"
        case .overflow:
            return "Overflow"
        case .invalidInput(let msg):
            return "Invalid input: \(msg)"
        case .parseError(let msg):
            return "Parse error: \(msg)"
        }
    }
}
