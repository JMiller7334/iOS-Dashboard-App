import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    @State private var selectedView: String = "Read"
    
    private let buttonHeight: CGFloat = 50  // Estimated height for buttons

    var body: some View {
        NavigationView {
            VStack {
                // Views for different tabs
                if selectedView == "Read" {
                    ReadTab(viewModel: viewModel)
                } else if selectedView == "Stats" {
                    Text("Stats View") // Replace with your Stats view
                } else if selectedView == "Write" {
                    WriteTab(viewModel: viewModel)
                }

                // Bottom buttons
                HStack {
                    Spacer()
                    Button(action: {
                        selectedView = "Read"
                    }) {
                        VStack {
                            Image(systemName: "tray.full")
                            Text("Read")
                        }
                    }
                    Spacer()
                    Button(action: {
                        selectedView = "Stats"
                    }) {
                        VStack {
                            Image(systemName: "chart.bar")
                            Text("Stats")
                        }
                    }
                    Spacer()
                    Button(action: {
                        selectedView = "Write"
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
            .navigationBarTitle(Text(selectedView), displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

