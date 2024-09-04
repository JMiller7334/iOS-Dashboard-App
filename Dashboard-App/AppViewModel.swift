//
//  AppViewModel.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/3/24.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {

    
    //MARK: - PICKER VIEW
    @Published var selectedTable: DatabaseTables = .tableCustomers
    @Published var customerCount: Int = 0
    @Published var outputText: String? = nil
    @Published var searchText: String = ""
    
    func performSearch() {
        //TODO:
    }

    func getCurrentTableName() -> String {
        switch selectedTable {
        case .tableCustomers:
            return "Reading from Customers Table"

        case .tableUsage:
            return "Reading from Usage Table"

        }
    }
}

