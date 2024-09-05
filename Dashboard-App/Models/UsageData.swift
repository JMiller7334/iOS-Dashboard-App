//
//  UsageData.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation
import SwiftUI

struct UsageData: Identifiable {
    let id = UUID() // Unique identifier
    
    let usageId: String
    let customerId: String
    let usageMonth: String
    let customerUsage: Double
    
    // Computed property for estimated profit
    var estProfit: Double {
        return customerUsage * 13.31
    }
}

// Sample data for previews
import SwiftUI

class PreviewData: ObservableObject {
    @Published var sampleData: [UsageData] = [
        UsageData(usageId: "", customerId: "", usageMonth: "Jan", customerUsage: 120.0),
        UsageData(usageId: "", customerId: "", usageMonth: "Feb", customerUsage: 150.0),
        UsageData(usageId: "", customerId: "", usageMonth: "Mar", customerUsage: 110.0),
        UsageData(usageId: "", customerId: "", usageMonth: "Apr", customerUsage: 140.0),
        UsageData(usageId: "", customerId: "", usageMonth: "May", customerUsage: 130.0),
        UsageData(usageId: "", customerId: "", usageMonth: "Jun", customerUsage: 160.0)
    ]
}


