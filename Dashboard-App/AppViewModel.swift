//
//  AppViewModel.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/3/24.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    
    //dependencies
    private let apiRepository = ApiRepository.shared
    
    
    //MARK: - SHARED
    @Published var selectedTable: DatabaseTables = .tableCustomers
    @Published var customerCount: Int = 0
    @Published var usageCount: Int = 0
    
    @Published var customerList: [Customer] = []
    @Published var usageList: [UsageData] = PreviewData().sampleData
    
    @Published var currentTab: AppTabs = .Read
    @Published var outputText: String? = nil
    
    init(){
        self.refresh()
    }
    
    public func getCurrentTableName() -> String {
        switch selectedTable {
        case .tableCustomers:
            return "Customers Table"

        case .tableUsage:
            return "Usage Table"

        }
    }
    
    public func refresh() {
        apiRepository.fetchCustomerData(searchId: nil, completion: {
            fetchedCustomers, error in
            
            guard error == nil else {
                return
            }
            
            self.customerList = fetchedCustomers
            self.customerCount = fetchedCustomers.count
        })
        
        apiRepository.fetchUsageRecords(searchId: nil, completion: {
            fetchedUsage, error in
            
            guard error == nil else {
                return
            }
            self.usageList = fetchedUsage
            self.usageCount = fetchedUsage.count
        })
    }
    
    
    //MARK: - STATS
    @Published var avgMonthlyProfit: Double = 0.0
    
    
    //MARK: - READ
    @Published var searchText: String = ""
    
    
    public func performSearch() {
        
        //case: customer table
        if selectedTable == .tableCustomers {
            apiRepository.fetchCustomerData(searchId: self.searchText, completion: {
                fetchedCustomers, error in
                
                guard !fetchedCustomers.isEmpty else {
                    self.outputText = "No results for ID: '\(self.searchText)'"
                    return
                }
                
                var newOutputText = ""
                for customer in fetchedCustomers {
                    newOutputText += customer.formatForDisplay()
                    newOutputText += "\n\n"
                    
                }
                self.outputText = newOutputText
            })
        
        //case: usage table
        } else {
            //TODO: IMPLEMENT SEARCH LOGIC
        }
    }
    
    
    //MARK: - WRITE
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

