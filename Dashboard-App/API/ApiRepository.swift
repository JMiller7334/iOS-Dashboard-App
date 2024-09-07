//
//  ApiRepository.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/6/24.
//

import Foundation

class ApiRepository {
    static let shared = ApiRepository()
    private let mySqlApi = MySqlApi.shared
    
    
    //MARK: - GET CUSTOMERS
    public func fetchCustomerData(searchId: String?, completion: @escaping ([Customer], Error?) -> Void) {
        
        //case: no id provided:
        if let validSearchId = searchId, !validSearchId.isEmpty {
            
            mySqlApi.fetchCustomerById(searchId: validSearchId, completion: {
                result in
                var customerArray: [Customer]
                var getCustomerError: Error?
                                
                switch result {
                case .success(let success):
                    if let validCustomer = success {
                        customerArray = [validCustomer]
                        
                    } else {
                        customerArray = []
                    }
                    getCustomerError = nil
                    
                case .failure(let failure):
                    customerArray = []
                    getCustomerError = failure
                }
                
                //logging
                print("api payload: \(customerArray) | server error: \(getCustomerError?.localizedDescription ?? "no error")")
                completion(customerArray, getCustomerError)
            })
            
        //case: no id provided:
        } else {
            
            //call
            mySqlApi.fetchCustomers() { result in
                var customerArray: [Customer] = []
                var getCustomerError: Error?
                
                switch result {
                case .success(let success):
                    customerArray = success
                    getCustomerError = nil
                    
                case .failure(let failure):
                    customerArray = []
                    getCustomerError = failure
                }
                
                //logging
                print("api payload: \(customerArray) | server error: \(getCustomerError?.localizedDescription ?? "no error")")
                completion(customerArray, getCustomerError)
            }
        }
    }
    
    
    //MARK: - FETCH USAGE RECORDS
    public func fetchUsageRecords(searchId: String?, completion: @escaping ([UsageData], Error?) -> Void) {
        mySqlApi.fetchUsageRecords(searchId: searchId, completion: { result in
            let usageArray: [UsageData]
            let getUsageError: Error?
            
            switch result {
            case .success(let success):
                usageArray = success
                getUsageError = nil
                
            case .failure(let failure):
                usageArray = []
                getUsageError = failure
            }
            
            //logging
            print("api payload: \(usageArray) | server error: \(getUsageError?.localizedDescription ?? "no error")")
            completion(usageArray, getUsageError)
        })
    }
}
