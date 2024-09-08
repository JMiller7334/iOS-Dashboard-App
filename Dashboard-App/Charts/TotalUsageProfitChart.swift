//
//  AverageUsageProfitChart.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import SwiftUI
import Charts

struct TotalUsageAndProfitChart: View {
    @Binding var data: [MonthlyUsageData]
    
    var body: some View {
        Chart {
            if data.isEmpty {
                RuleMark(y: .value("No data", 0))
                    .annotation {
                    Text("There is no usage to profit data at this time..")
                        .font(.footnote)
                        .padding(10)
                    }
                
            } else {
                
                ForEach(data) { item in
                    BarMark(
                        x: .value("Month", item.month.capitalizingFirstLetter()),
                        y: .value("Usage", item.totalUsage),
                        width: .fixed(20)
                    )
                    .foregroundStyle(.blue)
                    
                    BarMark(
                        x: .value("Month", item.month.capitalizingFirstLetter()),
                        y: .value("Profit", item.totalProfit),
                        width: .fixed(20)
                    )
                    .foregroundStyle(.orange)
                }
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .padding()
        .animation(.easeOut, value: data.isEmpty)
        .padding()
        .background(Color(.systemGray5))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.accentColor, lineWidth: 2)
        )
    }
}

// Preview for Average Usage and Profit Chart
struct TotalUsageAndProfitChart_Previews: PreviewProvider {
    static var previews: some View {
        // Creating a wrapper view to simulate @Binding for preview purposes
        PreviewWrapper()
    }

    // Wrapper view to simulate binding
    struct PreviewWrapper: View {
        @State private var sampleData = PreviewData().sampleData

        var body: some View {
            TotalUsageAndProfitChart(data: $sampleData)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}

