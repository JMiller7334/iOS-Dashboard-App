//
//  AvgProfitMetricView.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/5/24.
//

import SwiftUI

struct AvgMonthlyProfitMetricView: View {
    @Binding var averageProfit: Double
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "dollarsign.circle.fill")
                .foregroundColor(.accentColor)
                .font(.system(size: 17))
            Text(String(format: "Avg Monthly Profit: $%.2f", averageProfit))
                .font(.system(size: 15))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct AvgMonthlyProfitMetricView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var sampleProfit = 1234.56

        var body: some View {
            AvgMonthlyProfitMetricView(averageProfit: $sampleProfit)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}

