import SwiftUI

struct ContentView: View {
    @StateObject private var model = CalculatorModel()

    let buttons: [[CalculatorButton]] = [
        [.clear, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals]
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 12) {
                Spacer()

                // Display
                HStack {
                    Spacer()
                    Text(model.displayValue)
                        .foregroundColor(.white)
                        .font(.system(size: displayFontSize, weight: .light))
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .padding(.horizontal, 24)
                }

                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            CalculatorButtonView(button: button) {
                                model.buttonTapped(button)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }

    private var displayFontSize: CGFloat {
        let length = model.displayValue.count
        if length > 9 {
            return 50
        } else if length > 6 {
            return 70
        } else {
            return 96
        }
    }
}

struct CalculatorButtonView: View {
    let button: CalculatorButton
    let action: () -> Void

    @State private var isPressed = false

    private var buttonWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 12
        let totalSpacing = spacing * 3
        let unitWidth = (screenWidth - totalSpacing) / 4
        return button == .zero ? unitWidth * 2 + spacing : unitWidth
    }

    private var buttonHeight: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 12
        let totalSpacing = spacing * 3
        return (screenWidth - totalSpacing) / 4
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                buttonColor
                    .frame(width: buttonWidth, height: buttonHeight)
                    .cornerRadius(buttonHeight / 2)
                    .opacity(isPressed ? 0.7 : 1.0)

                if button == .zero {
                    HStack {
                        Text(button.rawValue)
                            .foregroundColor(Color(button.foregroundColor))
                            .font(.system(size: 34, weight: .medium))
                            .padding(.leading, 28)
                        Spacer()
                    }
                    .frame(width: buttonWidth)
                } else {
                    Text(button.rawValue)
                        .foregroundColor(Color(button.foregroundColor))
                        .font(.system(size: 34, weight: .medium))
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }

    private var buttonColor: Color {
        switch button.backgroundColor {
        case "operatorColor":
            return Color(red: 1.0, green: 0.621, blue: 0.039)
        case "functionColor":
            return Color(red: 0.647, green: 0.647, blue: 0.647)
        default:
            return Color(red: 0.2, green: 0.2, blue: 0.2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
