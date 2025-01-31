//
//  WriteTab.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation
import SwiftUI

struct WriteTab: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                TablePickerView(bindingValue: $viewModel.selectedTable)
                    .padding(.bottom, 5)
                
                ActionPickerView(selectedAction: $viewModel.databaseAction)
                
                CustomerMetricView(count: $viewModel.customerCount)
                    .padding(.vertical)
                UsageMetricView(count: $viewModel.usageCount)
                    .padding(.bottom, 30)
                
                if viewModel.databaseAction != .write {
                    InputView(bindingValue: $viewModel.searchText, hintText: viewModel.databaseAction.searchHint, keyboard: .numberPad,
                              
                        onKeyboardDismissed: {
                            viewModel.performSearch()
                    })
                    .padding(.bottom)
                }
                
                
                if viewModel.selectedTable == .tableCustomers && viewModel.databaseAction != .delete {
                    Text("Customer Table Inputs")
                        .fontWeight(.bold)
                    InputView(bindingValue: $viewModel.customerType, hintText: "Enter a customer type", keyboard: .default)
                    
                    InputView(bindingValue: $viewModel.customerName, hintText: "Enter customer name", keyboard: .default)
                    
                    InputView(bindingValue: $viewModel.customerPhone, hintText: "Enter phone number", keyboard: .phonePad)
                    
                    InputView(bindingValue: $viewModel.customerAddress, hintText: "Enter Address", keyboard: .default)
                    
                    InputView(bindingValue: $viewModel.customerEmail, hintText: "Enter email", keyboard: .emailAddress)
                    
                } else if viewModel.selectedTable == .tableUsage && viewModel.databaseAction != .delete {
                    Text("Customer Usage Inputs")
                        .fontWeight(.bold)
                    
                    InputView(bindingValue: $viewModel.usageCustomerId, hintText: "Enter related customer Id", keyboard: .numberPad)
                    
                    InputView(bindingValue: $viewModel.usageMonth, hintText: "Enter month of this record", keyboard: .default)
                    
                    InputView(bindingValue: $viewModel.usageAmount, hintText: "Enter usage for whole month", keyboard: .numberPad)
                }
                
                if viewModel.databaseAction != .write {
                    OutputView(outputText: $viewModel.outputText)
                } else {
                    Spacer()
                }
                
                Button(action: {
                    viewModel.writeToDatabase()
                    UIApplication.shared.endEditing(true)
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(13)
                        .background(Color.blue)
                        .cornerRadius(8)
                }.padding(.top, 8)
                
                
            }.padding()
        }
    }
}

struct WriteTab_Previews: PreviewProvider {
    static var previews: some View {
        WriteTab(viewModel: AppViewModel())
    }
}
