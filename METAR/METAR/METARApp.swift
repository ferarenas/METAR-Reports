import SwiftUI

@main
struct METARApp: App {
    var body: some Scene {
        WindowGroup {
            MetarReportsScreen(viewModel: MetarReportsScreenModel())
        }
    }
}
