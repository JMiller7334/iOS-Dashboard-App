//
//  Output.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation
import SwiftUI

struct OutputView: View {
    var fillerText: String = "Database output will display here.."
    @Binding var outputText: String?

    var body: some View {
        
        Text("Output")
        TextEditor(text: .constant(outputText ?? fillerText))
            .font(.system(size: 15))
            .disabled(true)
            .frame(maxWidth: .infinity, minHeight: 75)
            .padding()
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
