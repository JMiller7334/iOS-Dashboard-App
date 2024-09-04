//
//  TablePicker.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import SwiftUI

struct TablePickerView: View {
    
    @StateObject var viewModel: AppViewModel
    
    var body: some View {
        Picker("Select Table", selection: $viewModel.selectedTable) {
            ForEach(DatabaseTables.allCases, id: \.self) { table in
                Text(table.rawValue).tag(table)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        
    }
}
