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
            Text(viewModel.getCurrentTableName())
                .padding(.bottom)
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            TablePickerView(viewModel: viewModel)
                .padding(.bottom, 5)
            
            CustomerMetricView(count: viewModel.customerCount)
                .padding(.vertical)
            UsageMetricView(count: viewModel.customerCount)
                .padding(.bottom, 30)
            
            OutputView(outputText: viewModel.outputText)
            
            
            TextField("Enter Customer ID (ie: 1)", text: $viewModel.searchText)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.primary)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray3), lineWidth: 2)
                ).padding(.top, 5)
            
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
