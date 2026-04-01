import SwiftUI

struct CalculatorView: View {
    @StateObject var viewModel: CalculatorViewModel

    private let buttons: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7","8","9","×"],
        ["4","5","6","-"],
        ["1","2","3","+"],
        ["0",".","="]
    ]

    var body: some View {
        GeometryReader { geometry in
            // constants used for layout
            let spacing: CGFloat = 12
            let horizontalPadding: CGFloat = 16
            let totalWidth = geometry.size.width

            ZStack {
                // Dark background for the whole view
                Color(red: 10/255, green: 10/255, blue: 10/255)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: spacing) {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(viewModel.displayText)
                            .font(.system(size: 64))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding()
                            .foregroundColor(viewModel.isError ? .red : .white)
                    }

                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(row, id: \.self) { label in
                                Button(action: { tapped(label) }) {
                                    Text(label)
                                        .font(.system(size: 28))
                                        .frame(width: buttonWidth(label: label, totalWidth: totalWidth, spacing: spacing, horizontalPadding: horizontalPadding), height: 72)
                                        .background(buttonColor(label: label))
                                        .foregroundColor(buttonTextColor(label: label))
                                        .cornerRadius(36)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? geometry.safeAreaInsets.bottom : 16)
            }
        }
        // Force dark appearance for this view
        .preferredColorScheme(.dark)
    }

    private func tapped(_ label: String) {
        switch label {
        case "0"..."9":
            viewModel.tapDigit(label)
        case ".":
            viewModel.tapDigit(label)
        case "+", "-", "×", "÷", "*", "/":
            viewModel.tapOperator(label)
        case "=":
            viewModel.evaluate()
        case "AC":
            viewModel.clear()
        case "+/-":
            viewModel.toggleSign()
        case "%":
            viewModel.percent()
        default:
            break
        }
    }

    private func buttonWidth(label: String, totalWidth: CGFloat, spacing: CGFloat, horizontalPadding: CGFloat) -> CGFloat {
        // Calculate a 4-column grid width without using UIScreen.main
        // availableWidth subtracts horizontal padding and the 3 inter-column spacings
        let availableWidth = totalWidth - horizontalPadding * 2 - spacing * 3
        let columnWidth = availableWidth / 4
        if label == "0" {
            // zero spans two columns plus one spacing between them
            return columnWidth * 2 + spacing
        }
        return columnWidth
    }

    private func buttonColor(label: String) -> Color {
        switch label {
        case "AC", "+/-", "%":
            // function buttons - slightly lighter gray
            return Color(red: 80/255, green: 80/255, blue: 80/255)
        case "+", "-", "×", "÷", "=":
            // operator buttons - orange
            return Color(red: 255/255, green: 149/255, blue: 0/255)
        default:
            // number buttons - dark gray
            return Color(red: 40/255, green: 40/255, blue: 40/255)
        }
    }

    private func buttonTextColor(label: String) -> Color {
        switch label {
        case "AC", "+/-", "%":
            return .white
        case "+", "-", "×", "÷", "=":
            return .white
        default:
            return .white
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let useCase = CalculatorUseCase()
        let vm = CalculatorViewModel(useCase: useCase, repository: nil)
        CalculatorView(viewModel: vm)
            .previewDevice("iPhone 14")
            .preferredColorScheme(.dark)
    }
}
