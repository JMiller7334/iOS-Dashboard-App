//
//  InputView.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import SwiftUI

struct InputView: View {
    @Binding var bindingValue: String
    @FocusState var isFocused: Bool
    
    var hintText: String
    var keyboard: UIKeyboardType
    
    private let allowedToolbar: [UIKeyboardType] = [.decimalPad, .numberPad, .phonePad, .numbersAndPunctuation]
    
    var body: some View {
        TextField(hintText, text: $bindingValue)
            .keyboardType(keyboard)
            .focused($isFocused)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(.primary)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(.systemGray3), lineWidth: 2)
            )
            .padding(.top, 5)
        
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .toolbar {
                if isFocused {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            isFocused = false
                        }
                    }
                }
            }

    }
}

struct InputView_Previews: PreviewProvider {
    @State static var sampleValue = ""
    
    static var previews: some View {
        InputView(bindingValue: $sampleValue, hintText: "Enter Customer ID", keyboard: .numberPad)
    }
}

