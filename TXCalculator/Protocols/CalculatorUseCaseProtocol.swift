import Foundation

protocol CalculatorUseCaseProtocol {
    /// Evaluate an expression string (left-to-right, no operator precedence)
    func evaluate(expression: String) -> Result<CalculationResult, CalculationError>
    func performOperation(left: Double, op: String, right: Double) -> Result<Double, CalculationError>
}
