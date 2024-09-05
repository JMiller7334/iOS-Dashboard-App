//
//  AppViewModel.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/3/24.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {

    
    //MARK: - SHARED
    @Published var selectedTable: DatabaseTables = .tableCustomers
    @Published var customerCount: Int = 0
    @Published var usageCount: Int = 0
    
    public func getCurrentTableName() -> String {
        switch selectedTable {
        case .tableCustomers:
            return "Customers Table"

        case .tableUsage:
            return "Usage Table"

        }
    }
    
    
    //MARK: - READ
    @Published var outputText: String? = nil
    @Published var searchText: String = ""
    
    
    public func performSearch(){
        
    }
    
    
    //MARK: - WRITE VARIABLES:
    @Published var databaseAction: DatabaseActions = .write
    
    //customer records inputs
    @Published var customerType: String = ""
    @Published var customerName: String = ""
    @Published var customerPhone: String = ""
    @Published var customerAddress: String = ""
    @Published var customerEmail: String = ""
    
    //usage record inputs
    @Published var usageCustomerId: String = ""
    @Published var usageMonth: String = ""
    @Published var usageAmount: String = ""
    
    public func writeToDatabase(){
        
    }
}

