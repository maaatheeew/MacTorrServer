import SwiftUI

struct ContentView: View {
    let serverManager: ServerManager

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ServerStatusView(status: serverManager.status, errorMessage: serverManager.errorMessage)

            HStack(spacing: 12) {
                Button("Start Server", systemImage: "play.fill") {
                    Task { await serverManager.start() }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!serverManager.canStart)

                Button("Stop Server", systemImage: "stop.fill", action: serverManager.stop)
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .disabled(!serverManager.canStop)
            }

            ServerLinksView(endpoints: serverManager.endpoints)

        }
        .padding(32)
    }
}

#Preview {
    ContentView(serverManager: ServerManager())
}
