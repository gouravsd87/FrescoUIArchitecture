import SwiftUI
import MenuUI

/// Drop this file into a new iOS (17+) or macOS (14+) App target,
/// then add the `FrescoUI` package as a local dependency.
@main
struct MenuOrderingExampleApp: App {
    var body: some Scene {
        WindowGroup {
            MenuRootView()
        }
    }
}
