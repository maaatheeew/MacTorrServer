import SwiftUI

struct ServerLinksView: View {
    let endpoints: [ServerEndpoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Server Addresses")
                .font(.headline)

            ForEach(endpoints) { endpoint in
                LabeledContent(endpoint.role) {
                    Link(endpoint.url.absoluteString, destination: endpoint.url)
                        .textSelection(.enabled)
                }
            }
        }
    }
}
