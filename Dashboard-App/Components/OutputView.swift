//
//  Output.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation
import SwiftUI

struct OutputView: View {
    private var fillerText = "Results will display here."
    var outputText: String?
    
    init(fillerText: String = "Results will display here.", outputText: String?) {
        self.fillerText = fillerText
        self.outputText = outputText
    }

    var body: some View {
        
        Text("Output")
        TextEditor(text: .constant(outputText ?? fillerText))
            .font(.system(size: 15))
            .disabled(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
