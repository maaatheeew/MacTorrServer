import SwiftUI

struct ServerStatusView: View {
    let status: ServerStatus
    let errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(status.title, systemImage: status.systemImage)
                .font(.headline)
                .foregroundStyle(status == .failed ? .red : .primary)

            if let errorMessage {
                Text(errorMessage)
                    .font(.callout)
                    .foregroundStyle(.red)
            }
        }
    }
}
