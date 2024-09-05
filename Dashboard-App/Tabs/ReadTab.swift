//
//  ReadTab.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation
import SwiftUI

struct ReadTab: View {
    
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {            
            TablePickerView(bindingValue: $viewModel.selectedTable)
                .padding(.bottom, 5)
            
            CustomerMetricView(count: $viewModel.customerCount)
                .padding(.vertical)
            UsageMetricView(count: $viewModel.customerCount)
                .padding(.bottom, 30)
            
            OutputView(outputText: viewModel.outputText)
            
            InputView(bindingValue: $viewModel.searchText, hintText: "Enter Customer ID (ie: 1)", keyboard: .numberPad)
            
            // Search Button
            Button(action: {
                viewModel.performSearch()
            }) {
                Text("Search")
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .foregroundColor(.white) // Text color
                    .padding(13)
                    .background(Color.blue) // Button background color
                    .cornerRadius(8) // Rounded corners
            }.padding(.top, 8)
            
        }.padding()
    }
}

struct ReadTab_Previews: PreviewProvider {
    static var previews: some View {
        ReadTab(viewModel: AppViewModel())
    }
}
