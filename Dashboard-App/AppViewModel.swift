//
//  AppViewModel.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/3/24.
//

import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    
    
    //MARK: - ALERTS
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var alertTitle: String = ""
    
    private enum AlertType {
        case invalidInput
        case emptyField
        case idInput
        case monthInput
        case apiError
        case invalidEmail
        case invalidPhoneNumber
    }
    
    private func alertMessage(for type: AlertType) {
        switch type {
        case .invalidInput:
               alertTitle = "Input Error"
               alertMessage = "The input you provided seems to be incorrect. Please check and try again."
               
           case .emptyField:
               alertTitle = "Missing Information"
               alertMessage = "Some required fields are missing or empty. Please fill out all fields and try again."
               
           case .idInput:
               alertTitle = "Invalid ID"
               alertMessage = "The ID entered is invalid. Please ensure it is a valid number and try again."
               
           case .monthInput:
               alertTitle = "Invalid Month"
               alertMessage = "The month entered is not recognized. Please enter a valid month abbreviation (e.g., Jan, Feb) or full month name."
               
           case .apiError:
               alertTitle = "Request Error"
               alertMessage = "An error occurred while processing your request. Please check your network connection or try again later."
               
           case .invalidEmail:
               alertTitle = "Invalid Email Address"
               alertMessage = "The email address entered is not valid. Please enter a valid email address (e.g., example@domain.com)."
               
           case .invalidPhoneNumber:
               alertTitle = "Invalid Phone Number"
               alertMessage = "The phone number entered is not valid. Please enter a phone number in the format xxx-xxx-xxxx."
           }
        showAlert = true
    }
    private func triggerAlert(alertType: AlertType) {
        alertMessage(for: alertType)
     }
    
    //MARK: - VM PROPERTIES
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
    
    
    //MARK: GEN METRICS FUNC
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

    
    //MARK: REFRESH FUNC
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
            self.triggerAlert(alertType: .monthInput)
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
            
            self.triggerAlert(alertType: .emptyField)
            
            return nil
        }
        //input validation
        guard let validUsageMonth = self.validateDate(validInput: usageMonth) else {
            return nil
        }
        
        guard let validUsageAmount = Double(usageAmount),
              let validUsageCustId = Int(usageCustomerId) else {
            
            self.triggerAlert(alertType: .invalidInput)
            return nil
        }
        
        let newUsageData: UsageData
        if let validExistingId = fromExistingId {
            guard Int(validExistingId) != nil else {
                self.triggerAlert(alertType: .idInput)
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
                self.triggerAlert(alertType: .idInput)
                
                return
            }
            dataClass = buildUsageFromInuts(fromExistingId: searchText)
            
        //DELETE
        case .delete:
            httpMethod = "DELETE"
            guard !searchText.isEmpty, searchText != "",
                  let validDelId = Int(searchText) else {
                self.triggerAlert(alertType: .idInput)

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
            return
        }
        
        //API CALL
        self.apiRepository.handleDatabaseWrite(dataClass: validDataClass, httpMethod: httpMethod, sqlTable: sqlTable, completion: { result, error  in
            
            DispatchQueue.main.async {
                
                //case: write failure, notify user
                if let error = error {
                    self.triggerAlert(alertType: .apiError)
                    
                    //case: write success, refresh data
                } else {
                    self.usageMonth = ""
                    self.usageAmount = ""
                    self.usageCustomerId = ""
                    self.refresh()
                }
            }
        })
    }
    
    //MARK: WRITING CUSOTMERS
    private func buildCustomerFromInputs(fromExistingId: String?) -> Customer? {
        //input empty validation
        guard customerName != "",
                customerType != "",
                customerEmail != "",
                customerPhone != "",
                customerAddress != "" else {
            
            self.triggerAlert(alertType: .emptyField)
            
            return nil
        }
        
        // Input validation
        // Validate phone number
        let phoneNumberRegex = "^\\d{3}-\\d{3}-\\d{4}$" // Example format: xxx-xxx-xxxx
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        guard phonePredicate.evaluate(with: customerPhone) else {
            self.triggerAlert(alertType: .invalidPhoneNumber)
            return nil
        }
        
        // Validate email address
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$" // Basic email validation
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: customerEmail) else {
            self.triggerAlert(alertType: .invalidEmail)
            return nil
        }
        
        let newCustomerData: Customer
        if let validExistingId = fromExistingId {
            guard let validIntId = Int(validExistingId) else {
                self.triggerAlert(alertType: .idInput)
                return nil
            }
            
            newCustomerData = Customer(id: validIntId, customerType: customerType, name: customerName, phone: customerPhone, address: customerAddress, email: customerEmail)
            
        } else {
            newCustomerData = Customer(id: 0, customerType: customerType, name: customerName, phone: customerPhone, address: customerAddress, email: customerEmail)
        }
        return newCustomerData
    }
    
    
    private func handleCustomerWrite(){
        var httpMethod: String // "PUT", POST, DELETE
        var dataClass: Customer?
        let sqlTable = "customers"
        
        switch databaseAction {
            
        //UPDATE
        case .update:
            httpMethod = "PUT"
            guard searchText != "", (Int(searchText) != nil) else {
                self.triggerAlert(alertType: .idInput)
                
                return
            }
            dataClass = buildCustomerFromInputs(fromExistingId: searchText)
            
        //DELETE
        case .delete:
            httpMethod = "DELETE"
            guard !searchText.isEmpty, searchText != "",
                  let validDelId = Int(searchText) else {
                self.triggerAlert(alertType: .idInput)

                return
            }
            dataClass = Customer(id: validDelId, customerType: "", name: "", phone: "", address: "", email: "")
            
        //CREATE
        case .write:
            httpMethod = "POST"
            dataClass = buildCustomerFromInputs(fromExistingId: nil)
        }
        
        //validate data class validity
        guard let validDataClass = dataClass else {
            return
        }
        
        //API CALL
        self.apiRepository.handleDatabaseWrite(dataClass: validDataClass, httpMethod: httpMethod, sqlTable: sqlTable, completion: { result, error  in
            
            DispatchQueue.main.async {
                
                //case: write failure, notify user
                if let error = error {
                    self.triggerAlert(alertType: .apiError)
                    
                //case: write success, refresh data
                } else {
                    self.customerName = ""
                    self.customerEmail = ""
                    self.customerPhone = ""
                    self.customerAddress = ""
                    self.customerType = ""
                    self.refresh()
                }
            }
        })
    }
    
    
    //MARK: WRITTING DATABASE:
    public func writeToDatabase(){
        
        switch selectedTable {
        case .tableCustomers:
            self.handleCustomerWrite()
            
        case .tableUsage:
            self.handleUsageWrite()
        }
    }
}

