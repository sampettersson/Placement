import SwiftUI
@main
struct PlacementDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Form {
                    Section {
                        NavigationLink("PlacementThatFitsDemo") {
                            PlacementThatFitsDemo()
                        }
                        NavigationLink("CenterLayout") {
                            CenterLayoutDemo()
                        }
                        NavigationLink("BottomAttached") {
                            BottomAttachedDemo()
                        }
                    }
                }.navigationTitle("Placement")
            }
        }
    }
}
