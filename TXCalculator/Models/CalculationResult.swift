import Foundation

struct CalculationResult {
    let value: Double

    var formatted: String {
        if value.isNaN || value.isInfinite {
            return "Error"
        }
        // Trim trailing zeros and decimal point
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        formatter.usesGroupingSeparator = false
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
}
