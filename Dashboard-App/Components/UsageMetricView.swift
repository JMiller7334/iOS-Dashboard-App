//
//  UsageMetricView.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation
import SwiftUI

struct UsageMetricView: View {
    var count: Int // The usage metric value to display
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "chart.bar.fill")
                .foregroundColor(.blue)
                .font(.system(size: 17))
            Text("Usage Records: \(count)")
                .font(.system(size: 15))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct UsageMetricView_Previews: PreviewProvider {
    static var previews: some View {
        UsageMetricView(count: 1234) // Example usage metric
    }
}

