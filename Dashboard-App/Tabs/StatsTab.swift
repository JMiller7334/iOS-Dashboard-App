//
//  StatsTab.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation
import SwiftUI
import Charts

struct StatsTab: View {
    @StateObject var viewModel: AppViewModel
    
    var body: some View {
        ScrollView {
            VStack{
                CustomerMetricView(count: $viewModel.customerCount)
                    .padding(.horizontal)
                    .padding(.top)
                UsageMetricView(count: $viewModel.usageCount)
                    .padding(.horizontal)
                    .padding(.top)
                
                AvgMonthlyProfitMetricView(averageProfit: $viewModel.avgMonthlyProfit)
                    .padding()
                
                VStack {
                    
                    HStack {
                        Text("Monthly Usage: ")
                        Spacer()
                    }.padding(.horizontal)
                    
                    MonthlyUsageChart(data: $viewModel.usageList)
                    
                    HStack {
                        Text("Total Usage & Profits: ")
                        Spacer()
                    }.padding(.horizontal)
                        .padding(.top)
                    
                    TotalUsageAndProfitChart(data: $viewModel.usageList)
                    
                    // Legend
                    HStack {
                        legendItem(color: .blue, label: "Usage")
                        legendItem(color: .orange, label: "Profit")
                        Spacer()
                    }.padding()
                    
                    
                }.padding(.horizontal)
                Spacer()
            }
        }
    }
    
    private func legendItem(color: Color, label: String) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            Text(label)
                .font(.subheadline)
        }
    }
}

struct StatsTab_Previews: PreviewProvider {
    static var previews: some View {
        StatsTab(viewModel: AppViewModel())
    }
}
