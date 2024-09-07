//
//  Customer.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation

struct Customer: Identifiable, Codable {
    
    var id: Int
    var customerType: String
    var name: String
    var phone: String
    var address: String
    var email: String
    
    // Map JSON fields to Swift properties with CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case customerType = "customer_type"
        case name
        case phone
        case address
        case email
    }
    
    // Method to format the customer details for display
    private func formattedPhone() -> String {
        guard phone.count == 10 else { return phone }
        
        let areaCode = phone.prefix(3)
        let middle = phone.dropFirst(3).prefix(3)
        let last = phone.suffix(4)
        
        return "\(areaCode)-\(middle)-\(last)"
    }
    
    func formatForDisplay() -> String {
        return """
        ID: \(id)
        Customer Type: \(customerType)
        Name: \(name)
        Phone: \(self.formattedPhone())
        Address: \(address)
        Email: \(email)
        """
    }
}
