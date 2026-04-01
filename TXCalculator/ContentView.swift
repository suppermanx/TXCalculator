//
//  ContentView.swift
//  MyCalculator
//
//  Created by Supperman on 2026/3/31.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Forward to the new CalculatorView
        let useCase = CalculatorUseCase()
        let vm = CalculatorViewModel(useCase: useCase, repository: nil)
        CalculatorView(viewModel: vm)
    }
}

#Preview {
    ContentView()
}
