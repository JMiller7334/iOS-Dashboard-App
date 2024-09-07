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
    let usage_month: String
    let customer_usage: Double
    
    // Computed property for estimated profit
    var estProfit: Double {
        return customer_usage * 13.31
    }
}

// Sample data for previews
import SwiftUI


//MARK: TEST DATA
class PreviewData: ObservableObject {
    @Published var sampleData: [UsageData] = [
        UsageData(customerId: 0, usage_month: "Jan", customer_usage: 120.0),
        UsageData(customerId: 1, usage_month: "Feb", customer_usage: 150.0),
        UsageData(customerId: 2, usage_month: "Mar", customer_usage: 110.0),
        UsageData(customerId: 3, usage_month: "Apr", customer_usage: 140.0),
        UsageData(customerId: 4, usage_month: "May", customer_usage: 130.0),
        UsageData(customerId: 5, usage_month: "Jun", customer_usage: 160.0)
    ]
}


