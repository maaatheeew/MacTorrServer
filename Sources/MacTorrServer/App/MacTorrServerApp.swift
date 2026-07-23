import SwiftUI

@main
struct MacTorrServerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var serverManager = ServerManager()

    var body: some Scene {
        WindowGroup("MacTorrServer") {
            ContentView(serverManager: serverManager)
                .task {
                    appDelegate.serverManager = serverManager
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
        .defaultSize(width: 560, height: 470)
        .windowResizability(.contentSize)
    }
}
