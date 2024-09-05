//
//  TablePicker.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import SwiftUI

struct TablePickerView: View {
    
    @Binding var bindingValue: DatabaseTables
    
    var body: some View {
        Picker("Select Table", selection: $bindingValue) {
            ForEach(DatabaseTables.allCases, id: \.self) { table in
                Text(table.rawValue).tag(table)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        
    }
}
