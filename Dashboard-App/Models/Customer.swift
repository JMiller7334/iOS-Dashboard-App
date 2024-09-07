//
//  Customer.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation

struct Customer: Identifiable, Codable {
    
    var id: Int
    var customer_type: String
    var name: String
    var phone: String
    var address: String
    var email: String
    
}
