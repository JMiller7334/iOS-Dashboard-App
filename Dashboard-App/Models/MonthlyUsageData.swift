//
//  MonthlyUsageData.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/7/24.
//

import Foundation

struct MonthlyUsageData: Identifiable {
    
    var id = UUID()
    var month: String
    var totalUsage: Double
    var averageUsage: Double
    var totalProfit: Double
    
    //calculates metrics based on a list of provided data
    private mutating func calculateMetrics(from usageDataArray: [UsageData])  {
        guard usageDataArray.isEmpty == false else { return }
        var usages: [Double] = []
        
        //calculate total profit + total usage:
        for usageData in usageDataArray where usageData.usageMonth == self.month {
            usages.append(usageData.customerUsage)
            self.totalUsage += usageData.customerUsage
                
            if let profitAddition = Double(usageData.estProfit){
                self.totalProfit += profitAddition
            }
        }
        
        //calculate average usage:
        self.averageUsage = usages.isEmpty ? 0.0 : usages.reduce(0, +) / Double(usages.count)
    }
    
    //init
    init(month: String, usageDataArray: [UsageData]) {
        self.month = month
        self.totalUsage = 0.00
        self.averageUsage = 0.00
        self.totalProfit = 0.00
        
        self.calculateMetrics(from: usageDataArray)
    }
}

//MARK: TEST DATA
class PreviewData: ObservableObject {
    @Published var sampleData: [MonthlyUsageData] = [
        MonthlyUsageData(month: "Jan", usageDataArray: [
            UsageData(id: 1, customerId: 1001, usageMonth: "Jan", customerUsage: 320.5),
        ]),
        MonthlyUsageData(month: "Feb", usageDataArray: [
            UsageData(id: 2, customerId: 1002, usageMonth: "Feb", customerUsage: 290.7),
        ]),
        MonthlyUsageData(month: "Mar", usageDataArray: [
            UsageData(id: 3, customerId: 1003, usageMonth: "Mar", customerUsage: 310.2),
        ]),
        MonthlyUsageData(month: "Apr", usageDataArray: [
            UsageData(id: 4, customerId: 1004, usageMonth: "Apr", customerUsage: 315.8),
        ]),
        MonthlyUsageData(month: "May", usageDataArray: [
            UsageData(id: 5, customerId: 1005, usageMonth: "May", customerUsage: 300.4),
        ]),
        MonthlyUsageData(month: "Jun", usageDataArray: [
            UsageData(id: 6, customerId: 1006, usageMonth: "Jun", customerUsage: 275.6),
        ]),
        MonthlyUsageData(month: "Jul", usageDataArray: [
            UsageData(id: 7, customerId: 1007, usageMonth: "Jul", customerUsage: 290.2),
        ]),
        MonthlyUsageData(month: "Aug", usageDataArray: [
            UsageData(id: 8, customerId: 1008, usageMonth: "Aug", customerUsage: 320.8),
        ]),
        MonthlyUsageData(month: "Sep", usageDataArray: [
            UsageData(id: 9, customerId: 1009, usageMonth: "Sep", customerUsage: 310.0),
        ]),
        MonthlyUsageData(month: "Oct", usageDataArray: [
            UsageData(id: 10, customerId: 1010, usageMonth: "Oct", customerUsage: 305.3),
        ]),
        MonthlyUsageData(month: "Nov", usageDataArray: [
            UsageData(id: 11, customerId: 1011, usageMonth: "Nov", customerUsage: 290.9),
        ]),
        MonthlyUsageData(month: "Dec", usageDataArray: [
            UsageData(id: 12, customerId: 1012, usageMonth: "Dec", customerUsage: 315.7),
        ])
    ]
}

