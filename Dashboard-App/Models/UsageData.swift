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
    
    private func formattedMonth() -> String {
        let dateFormatter = DateFormatter()
           
        dateFormatter.dateFormat = "MMM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
           
        if let date = dateFormatter.date(from: usageMonth.capitalized) {
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: date)
            
        } else {
            return usageMonth
        }
    }
    
    
    public func formatForDisplay() -> String {
        return """
    -----------------------------------------
    ID: \(self.id)
    Related customer ID: \(self.customerId)
    Month of usage: \(formattedMonth())
    Amount of usage: \(self.customerUsage)kWh
    -----------------------------------------
    Amount billed: $\(estProfit)
    -----------------------------------------
    """
    }
    
}


