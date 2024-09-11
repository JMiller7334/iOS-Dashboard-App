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
    
    
    //MARK: - VALIDAITON
    private func validateDate(validInput: String) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM"
        
        let lowercasedInput = validInput.lowercased()
        
        if formatter.date(from: lowercasedInput) != nil {
            return validInput.lowercased()
        }
        guard let validMonth = formatter.date(from: lowercasedInput) else {
            return nil
        }
        return formatter.string(from: validMonth).lowercased()
    }
    
    
    //MARK: - WRITTING USAGE
    private func buildUsageFromInuts(fromExistingId: String?) -> UsageData? {
        //input empty validation
        guard usageAmount != "",
              usageMonth != "",
                usageCustomerId != "" else {
            //TODO: Notify user empty inputs
            return nil
        }
        //input validation
        guard let validUsageAmount = Double(usageAmount),
              let validUsageMonth = self.validateDate(validInput: usageMonth),
              let validUsageCustId = Int(usageCustomerId) else {
            //TODO: NOTIFY USER BAD INPUT
            return nil
        }
        
        let newUsageData: UsageData
        if let validExistingId = fromExistingId {
            guard let existingId = Int(validExistingId) else {
                //TODO: NOTIFY USER
                return nil
            }
            
            newUsageData = UsageData(id: validUsageCustId, customerId: validUsageCustId, usageMonth: validUsageMonth, customerUsage: validUsageAmount)
            
        } else {
            newUsageData = UsageData(customerId: validUsageCustId, usageMonth: validUsageMonth, customerUsage: validUsageAmount)
        }
        return newUsageData
    }
    
    
    private func handleUsageWrite(){
        var httpMethod: String // "PUT", POST, DELETE
        var dataClass: UsageData?
        let sqlTable = "usage"
        
        switch databaseAction {
            
        //UPDATE
        case .update:
            httpMethod = "PUT"
            guard searchText != "", (Int(searchText) != nil) else {
                //TODO: NOTIFY USER
                return
            }
            dataClass = buildUsageFromInuts(fromExistingId: searchText)
            
        //DELETE
        case .delete:
            httpMethod = "DELETE"
            guard !searchText.isEmpty, searchText != "",
                  let validDelId = Int(searchText) else {
                
                //TODO: notify user
                return
            }
            dataClass = UsageData(id: validDelId, customerId: 0, usageMonth: "", customerUsage: 0.00)
            
        //CREATE
        case .write:
            httpMethod = "POST"
            dataClass = buildUsageFromInuts(fromExistingId: nil)
        }
        
        //validate data class validity
        guard let validDataClass = dataClass else {
            //TODO: NOTIFY USER
            return
        }
        
        //API CALL
        self.apiRepository.handleDatabaseWrite(dataClass: validDataClass, httpMethod: httpMethod, sqlTable: sqlTable, completion: { result, error  in
            
            //case: write failure, notify user
            if let error = error {
                //TODO: NOTIFY USER
            
            //case: write success, refresh data
            } else {
                self.refresh()
            }
        })
    }
    
    //MARK: WRITING CUSOTMERS
    private func writeCustomers(){
        //TODO: logic
    }
    
    
    //MARK: WRITTING DATABASE:
    public func writeToDatabase(){
        
        switch selectedTable {
        case .tableCustomers:
            self.writeCustomers()
            
        case .tableUsage:
            self.handleUsageWrite()
        }
    }
}

