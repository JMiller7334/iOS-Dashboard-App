//
//  MySqlApi.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/6/24.
//

import Foundation

class MySqlApi {
    static let shared = MySqlApi()
    private let baseUrl = "http://jacobjmiller.com:8080/"
    
    
    //MARK: - SHARED API CALL
    func writeTables<T: Identifiable & Encodable>(dataClass: T, requestMethod: String, apiTable: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let apiTable = apiTable
        var apiUrl = "\(baseUrl)\(apiTable)"
        if requestMethod == "PUT" {
            apiUrl += "/\(dataClass.id)"
        }
        
        guard let url = URL(string: apiUrl) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let desiredStatus: [Int] = [200, 201, 204]
        performWriteRequest(encodableData: dataClass, url: url, requestMethod: requestMethod, desiredStatus: desiredStatus) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    
    // MARK: - WRITE HANDLER
    private func performWriteRequest<T: Encodable & Identifiable>(
        encodableData: T?,
        url: URL,
        requestMethod: String,
        desiredStatus: [Int],
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod
        if ["PUT", "POST"].contains(requestMethod) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let data = encodableData, ["PUT", "POST"].contains(requestMethod) {
            do {
                let jsonData = try JSONEncoder().encode(data)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               desiredStatus.contains(httpResponse.statusCode) {
                completion(.success("Write API operation successful"))
                
            } else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                let errorMessage = "Write API operation failed with status code: \(statusCode)"
                completion(.failure(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }
        task.resume()
    }


    
    //MARK: - READ HANDLER
    private func performReadRequest<T: Decodable>(url: URL, responseType: T.Type, requestMethod: (String), desiredStatus: [Int], completion: @escaping (Result<T, Error>) -> Void) {
        
         var request = URLRequest(url: url)
         request.httpMethod = requestMethod

         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             if let error = error {
                 DispatchQueue.main.async {
                     completion(.failure(error))
                 }
                 return
             }

             if let httpResponse = response as? HTTPURLResponse, !desiredStatus.contains(httpResponse.statusCode) {
                 
                 let statusError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid response: \(httpResponse.statusCode)"])
                 DispatchQueue.main.async {
                     completion(.failure(statusError))
                 }
                 return
             }

             guard let data = data else {
                 DispatchQueue.main.async {
                     completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                 }
                 return
             }

             if let responseString = String(data: data, encoding: .utf8) {
                 print("Raw response data: \(responseString) \n\n")
             }

             do {
                 let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                 DispatchQueue.main.async {
                     completion(.success(decodedResponse))
                 }
                 
                 
             } catch {
                 DispatchQueue.main.async {
                     print("Decoding error: \(error)")
                     completion(.failure(error))
                 }
             }
         }
         task.resume()
     }
     
     //MARK: - GET SINGLE CUSTOMER
     func fetchCustomerById(searchId: String, completion: @escaping (Result<Customer?, Error>) -> Void) {
         let apiTable = "customers"
         let apiUrl = "\(baseUrl)\(apiTable)?id=\(searchId)"
         guard let url = URL(string: apiUrl) else {
             completion(.failure(URLError(.badURL)))
             return
         }
         
         performReadRequest(url: url, responseType: Customer.self, requestMethod: "GET", desiredStatus: [200]) { result in
             switch result {
             case .success(let customer):
                 completion(.success(customer))
             case .failure(let error):
                 completion(.failure(error))
             }
         }
     }
     
     //MARK: - GET CUSTOMERS
     func fetchCustomers(completion: @escaping (Result<[Customer], Error>) -> Void) {
         let apiTable = "customers"
         let apiUrl = "\(baseUrl)\(apiTable)"
         guard let url = URL(string: apiUrl) else {
             completion(.failure(URLError(.badURL)))
             return
         }

         performReadRequest(url: url, responseType: [Customer].self, requestMethod: "GET", desiredStatus: [200]) { result in
             switch result {
             case .success(let customers):
                 completion(.success(customers))
             case .failure(let error):
                 completion(.failure(error))
             }
         }
    }
    
    
    //MARK: - GET USAGE RECORDS
    func fetchUsageRecords(searchId: String? ,completion: @escaping (Result<[UsageData], Error>) -> Void) {
        
        
        let apiTable = "usage"
        let apiUrl: String
        if let validSearchId = searchId, !validSearchId.isEmpty {
            apiUrl = "\(baseUrl)\(apiTable)?customerId=\(validSearchId)"
        } else {
            apiUrl = "\(baseUrl)\(apiTable)"
        }
        guard let url = URL(string: apiUrl) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        //call
        performReadRequest(url: url, responseType: [UsageData].self, requestMethod: "GET", desiredStatus: [200]) { result in
            
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    

    
    
    
    
    
    
 }
