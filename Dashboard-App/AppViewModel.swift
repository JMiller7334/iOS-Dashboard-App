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
    
    /**The months that charts, data models will check and generate data for.**/
    let recordedMonths: [String] = [
        "jan",
        "feb",
        "mar",
        "apr",
        "may",
        "jun",
        "jul",
        "aug",
        "sep",
        "oct",
        "nov",
        "dec"
    ]
    @Published var monthlyUsageList: [MonthlyUsageData] = []
    
    
    
    //MARK: - SHARED
    @Published var selectedTable: DatabaseTables = .tableCustomers {
        didSet {
            self.outputText = nil
            self.searchText = ""
        }
    }
    
    @Published var customerCount: Int = 0
    @Published var usageCount: Int = 0
    
    @Published var customerList: [Customer] = []
    @Published var usageList: [UsageData] = []
    
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
    
    
    /*generate data for charts and metrics **/
    private func generateMetricData() {
        self.monthlyUsageList = []
        
        for month in self.recordedMonths {
            let newMonthlyRecord = MonthlyUsageData(month: month, usageDataArray: self.usageList)
            self.monthlyUsageList.append(newMonthlyRecord)
        }
        
        let totalProfit = self.monthlyUsageList.reduce(0.0) { (result, record) -> Double in
            return result + record.totalProfit
        }
        
        let numberOfMonths = self.monthlyUsageList.count
        let averageMonthlyProfit = numberOfMonths > 0 ? totalProfit / Double(numberOfMonths) : 0.0
        
        self.avgMonthlyProfit = averageMonthlyProfit
    }

    
    public func refresh() {
        self.searchText = ""
        self.outputText = nil
        
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
            
            self.generateMetricData()
            
        })
    }
    
    public func onTabChanged(){
        self.searchText = ""
        self.outputText = nil
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
                    newOutputText += "\n\n\n"
                    
                }
                self.outputText = newOutputText
            })
        
        //case: usage table
        } else {
            
            //case local search performed (by id)
            if currentTab == .Write && selectedTable == .tableUsage {
                self.performUsageLocalSearch()
            
            //case api search performed (by customer id)
            } else {
                
                apiRepository.fetchUsageRecords(searchId: self.searchText, completion: { fetchedRecords, error in
                    
                    guard !fetchedRecords.isEmpty else {
                        self.outputText = "No results for ID: '\(self.searchText)'"
                        return
                    }
                    
                    var newOutputText = ""
                    for record in fetchedRecords {
                        newOutputText += record.formatForDisplay()
                        newOutputText += "\n\n\n"
                    }
                    self.outputText = newOutputText
                })
            }
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
    
    //MARK: - LOCAL USAGE SEARCH
    private func performUsageLocalSearch(){
        print("n/n/ performing local search on usage")
        guard self.searchText.isEmpty == false else {
            var outputDirectory = ""
            for dataUsage in self.usageList {
                outputDirectory += dataUsage.formatForDisplay()
                outputDirectory += "\n\n\n"
            }
            self.outputText = outputDirectory
            return
        }
        
        guard let validSearchTerm = Int(self.searchText) else {
            self.outputText = "Error: Invalid input"
            return
        }
        
        guard let searchResult = usageList.first(where: { $0.id == validSearchTerm }) else {
            self.outputText = "No result for ID: '\(validSearchTerm)'"
            return
        }
        self.outputText = searchResult.formatForDisplay()
    }
    
    
    public func writeToDatabase(){
        
    }
}

