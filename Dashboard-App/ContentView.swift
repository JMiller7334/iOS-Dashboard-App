import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    
    private let buttonHeight: CGFloat = 50  // Estimated height for buttons
    private var navtitle = "Read"

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
                        resignFirstResponder()
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
                        resignFirstResponder()
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
                        resignFirstResponder()
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
                
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            

            .navigationBarTitle(Text(viewModel.navTitle), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    refreshButton
                }
            }

        }
    }
    
    func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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

import UIKit
extension UIApplication {
    func endEditing(_ force: Bool) {
        guard let windowScene = connectedScenes
                .first(where: { $0 is UIWindowScene }) as? UIWindowScene else { return }
        windowScene.windows
            .filter { $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}


