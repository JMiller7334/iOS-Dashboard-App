//
//  CustomerMetricView.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation
import SwiftUI

struct CustomerMetricView: View {
    var count: Int

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "person.fill")
                .foregroundColor(.blue)
                .font(.system(size: 17))
            Text("Customer Records: \(count)")
                .font(.system(size: 15))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct UsageCustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerMetricView(count: 127) // Example usage metric
    }
}

