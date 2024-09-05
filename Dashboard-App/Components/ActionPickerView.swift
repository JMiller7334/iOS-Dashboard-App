//
//  ActionPickerView.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import SwiftUI

struct ActionPickerView: View {
    @Binding var selectedAction: DatabaseActions

    var body: some View {
        Picker("Select Action", selection: $selectedAction) {
            ForEach(DatabaseActions.allCases, id: \.self) { action in
                Text(action.rawValue.capitalized)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.top, 5)
    }
}


struct ActionPickerView_Previews: PreviewProvider {
    @State static var selectedAction = DatabaseActions.update

    static var previews: some View {
        ActionPickerView(selectedAction: $selectedAction)
    }
}

