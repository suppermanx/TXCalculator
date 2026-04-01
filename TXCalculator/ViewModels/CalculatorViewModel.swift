import Foundation
import Combine

import SwiftUI

final class CalculatorViewModel: ObservableObject {
    @Published private(set) var displayText: String = "0"
    @Published private(set) var isError: Bool = false

    private var inputBuffer: String = "" // raw expression
    private let useCase: CalculatorUseCaseProtocol
    private let repository: CalculatorRepositoryProtocol?

    init(useCase: CalculatorUseCaseProtocol, repository: CalculatorRepositoryProtocol? = nil) {
        self.useCase = useCase
        self.repository = repository
    }

    // MARK: - UI Actions

    func tapDigit(_ digit: String) {
        guard digit == "." || (digit.count == 1 && digit.first!.isNumber) else { return }

        // Prevent multiple decimals in the current number
        if digit == "." {
            if currentNumberContainsDecimal() { return }
            if inputBuffer.isEmpty || lastTokenIsOperator() {
                inputBuffer.append("0")
            }
        }

        // Prevent leading zeros like 000
        if digit == "0" {
            if lastTokenIsNumber() {
                // if current number is "0" then ignore additional leading zeros
                if currentNumberIsZero() {
                    return
                }
            }
        }

        inputBuffer.append(digit)
        updateDisplayFromBuffer()
    }

    func tapOperator(_ op: String) {
        guard ["+","-","×","÷","*","/"].contains(op) else { return }

        // If buffer empty and op is -, allow negative number start
        if inputBuffer.isEmpty && op == "-" {
            inputBuffer.append(op)
            updateDisplayFromBuffer()
            return
        }

        // Replace trailing operator
        if lastTokenIsOperator() {
            // replace last operator with new one
            inputBuffer.removeLast()
            inputBuffer.append(op)
        } else {
            inputBuffer.append(op)
        }
        updateDisplayFromBuffer()
    }

    func backspace() {
        guard !inputBuffer.isEmpty else { return }
        inputBuffer.removeLast()
        updateDisplayFromBuffer()
    }

    func clear() {
        inputBuffer = ""
        displayText = "0"
        isError = false
    }

    func toggleSign() {
        // Toggle sign of the current number token
        let (prefix, number, suffix) = splitBufferAroundCurrentNumber()
        guard !number.isEmpty else { return }
        if number.first == "-" {
            let newNumber = String(number.dropFirst())
            inputBuffer = prefix + newNumber + suffix
        } else {
            let newNumber = "-" + number
            inputBuffer = prefix + newNumber + suffix
        }
        updateDisplayFromBuffer()
    }

    func percent() {
        // Convert current number to percent (divide by 100)
        let (prefix, numberStr, suffix) = splitBufferAroundCurrentNumber()
        guard let value = Double(numberStr) else { return }
        let newValue = value / 100.0
        inputBuffer = prefix + String(newValue) + suffix
        updateDisplayFromBuffer()
    }

    func evaluate() {
        isError = false
        let expr = inputBuffer
        let result = useCase.evaluate(expression: expr)
        switch result {
        case .success(let calc):
            displayText = calc.formatted
            repository?.save(historyEntry: "\(expr) = \(calc.formatted)")
            inputBuffer = String(calc.value)
        case .failure(let err):
            isError = true
            displayText = err.description
        }
    }

    // MARK: - Helpers

    private func updateDisplayFromBuffer() {
        if inputBuffer.isEmpty {
            displayText = "0"
            return
        }
        displayText = inputBuffer
    }

    private func lastTokenIsOperator() -> Bool {
        guard let last = inputBuffer.last else { return false }
        return ["+","-","×","÷","*","/"].contains(String(last))
    }

    private func lastTokenIsNumber() -> Bool {
        guard let last = inputBuffer.last else { return false }
        return last.isNumber || last == "."
    }

    private func currentNumberContainsDecimal() -> Bool {
        let (_, number, _) = splitBufferAroundCurrentNumber()
        return number.contains(".")
    }

    private func currentNumberIsZero() -> Bool {
        let (_, number, _) = splitBufferAroundCurrentNumber()
        // consider "0", "0." as zero
        if number == "0" { return true }
        if number.hasPrefix("0") && !number.contains(".") {
            // leading zeros
            return true
        }
        return false
    }

    private func splitBufferAroundCurrentNumber() -> (String, String, String) {
        // Return (prefix, currentNumber, suffix)
        // Find last operator position
        var idx = inputBuffer.endIndex
        var i = inputBuffer.index(before: idx)
        var start = inputBuffer.startIndex
        while true {
            if i < inputBuffer.startIndex { break }
            let ch = inputBuffer[i]
            if ["+","-","×","÷","*","/"].contains(String(ch)) {
                start = inputBuffer.index(after: i)
                break
            }
            if i == inputBuffer.startIndex { start = inputBuffer.startIndex; break }
            i = inputBuffer.index(before: i)
        }

        let prefix = String(inputBuffer[inputBuffer.startIndex..<start])
        let suffix = "" // we don't support cursor in middle; suffix always empty
        let number = String(inputBuffer[start..<inputBuffer.endIndex])
        return (prefix, number, suffix)
    }
}
