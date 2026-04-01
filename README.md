# TXCalculator

TXCalculator is a lightweight iOS calculator app built with SwiftUI. It follows a clean, layered architecture (`View -> ViewModel -> UseCase -> Repository`) so UI logic and business logic stay separated and testable.

## Features

- Basic arithmetic: `+`, `-`, `×`, `÷` (also supports `*` and `/` internally)
- Decimal input validation (prevents duplicate decimal points in one number)
- Sign toggle (`+/-`) and percentage conversion (`%`)
- Input editing with `AC` and backspace-ready ViewModel logic
- Error handling for invalid input, parse errors, divide-by-zero, and overflow

## Architecture

The app is organized by responsibility:

- `Views/`
  - SwiftUI screens and layout (`CalculatorView`)
- `ViewModels/`
  - UI state and user interaction handling (`CalculatorViewModel`)
- `UseCases/`
  - Core calculation rules and expression evaluation (`CalculatorUseCase`)
- `Repositories/`
  - Data persistence abstraction and in-memory implementation
- `Protocols/`
  - Contracts for use case and repository, enabling dependency injection
- `Models/`
  - Domain models and error definitions (`CalculationResult`, `CalculationError`)

### Data Flow

1. User taps a button in `CalculatorView`
2. `CalculatorViewModel` updates input state or triggers evaluation
3. `CalculatorUseCase` parses and evaluates the expression
4. `CalculatorViewModel` publishes display text and error state back to the view
5. Optional history entry is saved via `CalculatorRepositoryProtocol`

## Project Structure

```text
TXCalculator/
  TXCalculator/
    Models/
    Protocols/
    Repositories/
    UseCases/
    ViewModels/
    Views/
    Assets.xcassets/
    ContentView.swift
    TXCalculatorApp.swift
  TXCalculatorTests/
  TXCalculatorUITests/
  TXCalculator.xcodeproj/
  tools/
    generate_app_icon.py
```

## Requirements

- macOS with Xcode installed
- iOS Simulator or physical iOS device

(Deployment target and build settings are defined in `TXCalculator.xcodeproj`.)

## Getting Started

Open in Xcode:

```bash
cd /Users/supperman/Documents/GitHub/TXCalculator
open TXCalculator.xcodeproj
```

Then in Xcode:

1. Select the `TXCalculator` scheme.
2. Choose a simulator (for example, iPhone 14).
3. Press Run (`Cmd + R`).

## Running Tests

In Xcode:

- Run all tests with `Cmd + U`
- Unit tests target: `TXCalculatorTests`
- UI tests target: `TXCalculatorUITests`

Or from terminal:

```bash
cd /Users/supperman/Documents/GitHub/TXCalculator
xcodebuild test \
  -project TXCalculator.xcodeproj \
  -scheme TXCalculator \
  -destination 'platform=iOS Simulator,name=iPhone 14'
```

## Notes

- Current expression evaluation is left-to-right (no operator precedence).
- The architecture is ready for extension (for example, adding persistent history or scientific operations).
