import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    
    private let buttonHeight: CGFloat = 50  // Estimated height for buttons

    var body: some View {
        NavigationView {
            VStack {
                
                switch viewModel.currentTab {
                case .Read:
                    ReadTab(viewModel: self.viewModel)
                case .Write:
                    WriteTab(viewModel: self.viewModel)
                case .Stats:
                    StatsTab(viewModel: self.viewModel)
                }
                
                // Bottom buttons
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.currentTab = .Read
                        viewModel.onTabChanged()
                    }) {
                        VStack {
                            Image(systemName: "tray.full")
                            Text("Read")
                        }
                    }
                    Spacer()
                    Button(action: {
                        viewModel.currentTab = .Stats
                        viewModel.onTabChanged()
                    }) {
                        VStack {
                            Image(systemName: "chart.bar")
                            Text("Stats")
                        }
                    }
                    Spacer()
                    Button(action: {
                        viewModel.currentTab = .Write
                        viewModel.onTabChanged()
                    }) {
                        VStack {
                            Image(systemName: "pencil.and.outline")
                            Text("Write")
                        }
                    }
                    Spacer()
                }
                .padding()
                .frame(height: buttonHeight)
                .background(Color(UIColor.systemBackground))
                .shadow(radius: 4)
            }
            
            .navigationBarTitle(Text(viewModel.currentTab.rawValue), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    refreshButton
                }
            }

        }
    }
    
    // Define the refresh button
    private var refreshButton: some View {
        Button(action: {
            viewModel.refresh()
        }) {
            Image(systemName: "arrow.clockwise")
            .font(.system(size: 15))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

