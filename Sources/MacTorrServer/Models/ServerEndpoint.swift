import Foundation

struct ServerEndpoint: Identifiable, Equatable {
    let host: String
    let port: Int

    var id: String { url.absoluteString }

    var url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.port = port
        return components.url ?? URL(filePath: "/")
    }

    var role: String {
        host == "127.0.0.1" ? "This Mac" : "Local Network"
    }
}
