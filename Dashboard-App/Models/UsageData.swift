//
//  UsageData.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation
import SwiftUI

struct UsageData: Identifiable, Codable {
    var id: Int = 0 // Unique identifier
    
    let customerId: Int
    let usageMonth: String
    let customerUsage: Double
    
    // Computed property for estimated profit
    var estProfit: String {
        let profit = customerUsage * 0.20
        return String(format: "%.2f", profit)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case customerId
        case usageMonth = "usage_month"
        case customerUsage = "customer_usage"
    }
    
    public func formatForDisplay() -> String {
        return """
    ID: \(self.id)
    Related Customer ID: \(self.customerId)
    Month of Usage: \(self.usageMonth)
    Amount of Usage: \(self.customerUsage)kWh
    
    Amount Billed: $\(estProfit)
    """
    }
    
}

// Sample data for previews
import SwiftUI


//MARK: TEST DATA
class PreviewData: ObservableObject {
    @Published var sampleData: [UsageData] = [
        UsageData(customerId: 0, usageMonth: "Jan", customerUsage: 120.0),
        UsageData(customerId: 1, usageMonth: "Feb", customerUsage: 150.0),
        UsageData(customerId: 2, usageMonth: "Mar", customerUsage: 110.0),
        UsageData(customerId: 3, usageMonth: "Apr", customerUsage: 140.0),
        UsageData(customerId: 4, usageMonth: "May", customerUsage: 130.0),
        UsageData(customerId: 5, usageMonth: "Jun", customerUsage: 160.0)
    ]
}


