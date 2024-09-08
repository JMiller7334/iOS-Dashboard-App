//
//  Output.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import SwiftUI

struct OutputView: View {
    var fillerText: String = "Database output will display here."
    @Binding var outputText: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Output")
                .font(.headline)
                .padding(.bottom, 5)
                .padding(.horizontal)

            ScrollView {
                Text(outputText ?? fillerText)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.clear)
            }
            .frame(maxWidth: .infinity, minHeight: 75, maxHeight: 300)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
    }
}

struct OutputView_Previews: PreviewProvider {
    @State static var sampleValue: String? = nil
    
    static var previews: some View {
        OutputView(outputText: $sampleValue)
    }
}
