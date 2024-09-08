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
    
    //MARK: REQUEST HANDLER
    private func performRequest<T: Decodable>(url: URL, responseType: T.Type, desiredStatus: [Int], completion: @escaping (Result<T, Error>) -> Void) {
         var request = URLRequest(url: url)
         request.httpMethod = "GET"

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
         
         performRequest(url: url, responseType: Customer.self, desiredStatus: [200]) { result in
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

         performRequest(url: url, responseType: [Customer].self, desiredStatus: [200]) { result in
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
        performRequest(url: url, responseType: [UsageData].self, desiredStatus: [200]) { result in
            
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    

    
    
    
    
    
    
 }
