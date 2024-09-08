//
//  MonthlyUsageChart.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//
import SwiftUI
import Charts

// View showing the Monthly Usage Trend Chart
struct MonthlyUsageChart: View {
    @Binding var data: [MonthlyUsageData]
    
    var body: some View {
        Chart {
            
            if data.isEmpty {
                RuleMark(y: .value("No data", 0))
                    .annotation {
                    Text("There is no usage data at this time..")
                        .font(.footnote)
                        .padding(10)
                    }
                
            } else {
                
                ForEach(data){ item in
                    LineMark(x: .value("Month", item.month.capitalizingFirstLetter()),
                        y: .value("Usage", item.totalUsage))
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                    .symbol(.circle)
                }
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .animation(.easeOut, value: data.isEmpty)
        .padding()
        .background(Color(.systemGray5))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.accentColor, lineWidth: 2)
        )
    }
}


// Preview for monthly usage chart
struct MonthlyUsageChart_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    struct PreviewWrapper: View {
        @State private var sampleData = PreviewData().sampleData

        var body: some View {
            MonthlyUsageChart(data: $sampleData)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}

