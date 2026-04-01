//
//  MyCalculatorApp.swift
//  MyCalculator
//
//  Created by Supperman on 2026/3/31.
//

import SwiftUI

@main
struct TXCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            let repository = InMemoryCalculatorRepository()
            let useCase = CalculatorUseCase()
            let vm = CalculatorViewModel(useCase: useCase, repository: repository)
            CalculatorView(viewModel: vm)
        }
    }
}
