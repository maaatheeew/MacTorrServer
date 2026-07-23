import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    var serverManager: ServerManager?

    func applicationWillTerminate(_ notification: Notification) {
        serverManager?.stop()
    }
}
