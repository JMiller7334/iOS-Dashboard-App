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
    var onKeyboardDismissed: (() -> Void)?
    
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
                    ToolbarItemGroup(placement: .automatic) {
                        Spacer()
                        Button("Close Keyboard") {
                            isFocused = false
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.accentColor, lineWidth: 1.5)
                        )
                    }
                }
            }
        .onChange(of: isFocused) {_, newValue in
            if !newValue {
                onKeyboardDismissed?()
            }
        }

    }
}

struct InputView_Previews: PreviewProvider {
    @State static var sampleValue = ""
    
    static var previews: some View {
        InputView(bindingValue: $sampleValue, hintText: "Enter Customer ID", keyboard: .numberPad )
    }
}

