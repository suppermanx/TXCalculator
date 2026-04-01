import Foundation

final class CalculatorUseCase: CalculatorUseCaseProtocol {
    func evaluate(expression: String) -> Result<CalculationResult, CalculationError> {
        // Tokenize by characters into numbers and operators
        let tokens = tokenize(expression: expression)
        guard !tokens.isEmpty else {
            return .failure(.invalidInput("Empty expression"))
        }

        // Expect sequence: number (op number)*
        var index = 0
        guard case .number(let first) = tokens[index] else {
            return .failure(.parseError("Expression must start with a number"))
        }
        var current = first
        index += 1

        while index < tokens.count {
            guard case .op(let op) = tokens[index] else {
                return .failure(.parseError("Expected operator at position \(index)"))
            }
            index += 1
            if index >= tokens.count {
                return .failure(.parseError("Trailing operator"))
            }
            guard case .number(let next) = tokens[index] else {
                return .failure(.parseError("Expected number after operator"))
            }
            index += 1

            switch performOperation(left: current, op: op, right: next) {
            case .success(let result):
                current = result
            case .failure(let err):
                return .failure(err)
            }
        }

        if !current.isFinite {
            return .failure(.overflow)
        }

        return .success(CalculationResult(value: current))
    }

    func performOperation(left: Double, op: String, right: Double) -> Result<Double, CalculationError> {
        switch op {
        case "+":
            let result = left + right
            return result.isFinite ? .success(result) : .failure(.overflow)
        case "-":
            let result = left - right
            return result.isFinite ? .success(result) : .failure(.overflow)
        case "×", "*":
            let result = left * right
            return result.isFinite ? .success(result) : .failure(.overflow)
        case "÷", "/":
            if right == 0 {
                return .failure(.divideByZero)
            }
            let result = left / right
            return result.isFinite ? .success(result) : .failure(.overflow)
        default:
            return .failure(.invalidInput("Unknown operator \(op)"))
        }
    }

    private enum Token {
        case number(Double)
        case op(String)
    }

    private func tokenize(expression: String) -> [Token] {
        var tokens: [Token] = []
        var numberBuffer: String = ""

        func flushNumber() {
            if !numberBuffer.isEmpty {
                if let value = Double(numberBuffer) {
                    tokens.append(.number(value))
                } else {
                    // push NaN to cause parse error later
                    tokens.append(.number(Double.nan))
                }
                numberBuffer = ""
            }
        }

        for ch in expression {
            if ch.isNumber || ch == "." {
                numberBuffer.append(ch)
            } else if ch == "+" || ch == "-" || ch == "×" || ch == "÷" || ch == "*" || ch == "/" {
                flushNumber()
                tokens.append(.op(String(ch)))
            } else if ch.isWhitespace {
                // skip
                flushNumber()
            } else {
                // invalid character -> record as invalid token by adding to number buffer to fail parse
                numberBuffer.append(ch)
            }
        }
        flushNumber()
        return tokens
    }
}
