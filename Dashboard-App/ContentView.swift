//
//  ContentView.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = AppViewModel()
    
    var body: some View {
        TabView {
            
            //MARK: - READ
            ReadTab(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "tray.full")
                    Text("Read")
                }
            
            
            //MARK: - STATS
            Text("Stats View")
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Stats")
                }

            
            //MARK: - WRITE
            Text("Profile View")
                .tabItem {
                    Image(systemName: "pencil.and.outline")
                    Text("Write")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
