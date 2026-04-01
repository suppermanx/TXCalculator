import Foundation

enum CalculatorButton: String {
    case zero = "0", one = "1", two = "2", three = "3", four = "4"
    case five = "5", six = "6", seven = "7", eight = "8", nine = "9"
    case add = "+", subtract = "−", multiply = "×", divide = "÷"
    case equals = "=", decimal = ".", percent = "%", plusMinus = "+/-"
    case clear = "AC"

    var backgroundColor: String {
        switch self {
        case .add, .subtract, .multiply, .divide, .equals:
            return "operatorColor"
        case .clear, .plusMinus, .percent:
            return "functionColor"
        default:
            return "digitColor"
        }
    }

    var foregroundColor: String {
        switch self {
        case .clear, .plusMinus, .percent:
            return "functionTextColor"
        default:
            return "white"
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

class CalculatorModel: ObservableObject {
    @Published var displayValue: String = "0"

    private let maxDisplayLength = 9
    private var currentValue: Double = 0
    private var storedValue: Double = 0
    private var currentOperation: Operation = .none
    private var shouldResetDisplay = false

    func buttonTapped(_ button: CalculatorButton) {
        switch button {
        case .clear:
            reset()
        case .plusMinus:
            toggleSign()
        case .percent:
            applyPercent()
        case .add:
            setOperation(.add)
        case .subtract:
            setOperation(.subtract)
        case .multiply:
            setOperation(.multiply)
        case .divide:
            setOperation(.divide)
        case .equals:
            calculate()
        case .decimal:
            appendDecimal()
        default:
            appendDigit(button.rawValue)
        }
    }

    private func reset() {
        displayValue = "0"
        currentValue = 0
        storedValue = 0
        currentOperation = .none
        shouldResetDisplay = false
    }

    private func toggleSign() {
        if let value = Double(displayValue) {
            let toggled = value * -1
            displayValue = formatResult(toggled)
            currentValue = toggled
        }
    }

    private func applyPercent() {
        if let value = Double(displayValue) {
            let result = value / 100
            displayValue = formatResult(result)
            currentValue = result
        }
    }

    private func setOperation(_ operation: Operation) {
        if let value = Double(displayValue) {
            storedValue = value
        }
        currentOperation = operation
        shouldResetDisplay = true
    }

    private func calculate() {
        guard let value = Double(displayValue) else { return }
        currentValue = value

        var result: Double
        switch currentOperation {
        case .add:
            result = storedValue + currentValue
        case .subtract:
            result = storedValue - currentValue
        case .multiply:
            result = storedValue * currentValue
        case .divide:
            result = currentValue != 0 ? storedValue / currentValue : 0
        case .none:
            return
        }

        displayValue = formatResult(result)
        storedValue = result
        currentOperation = .none
        shouldResetDisplay = true
    }

    private func appendDigit(_ digit: String) {
        if shouldResetDisplay {
            displayValue = digit
            shouldResetDisplay = false
        } else {
            if displayValue == "0" {
                displayValue = digit
            } else {
                if displayValue.count < maxDisplayLength {
                    displayValue += digit
                }
            }
        }
    }

    private func appendDecimal() {
        if shouldResetDisplay {
            displayValue = "0."
            shouldResetDisplay = false
            return
        }
        if !displayValue.contains(".") {
            displayValue += "."
        }
    }

    private func formatResult(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 && !value.isInfinite && !value.isNaN {
            let intValue = Int(value)
            return "\(intValue)"
        } else {
            let formatted = String(format: "%.8g", value)
            return formatted
        }
    }
}
