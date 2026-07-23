import Testing
@testable import MacTorrServer

struct ServerEndpointTests {
    @Test func createsTheLuxoAddress() {
        let endpoint = ServerEndpoint(host: "192.168.1.25", port: 8090)

        #expect(endpoint.url.absoluteString == "http://192.168.1.25:8090")
        #expect(endpoint.role == "Local Network")
    }

    @Test func identifiesTheMacAddress() {
        let endpoint = ServerEndpoint(host: "127.0.0.1", port: 8090)

        #expect(endpoint.role == "This Mac")
    }

    @Test func keepsOnlyHomeNetworkAddresses() {
        #expect(NetworkAddressProvider.isPrivateLANAddress("192.168.0.16"))
        #expect(NetworkAddressProvider.isPrivateLANAddress("10.0.0.7"))
        #expect(NetworkAddressProvider.isPrivateLANAddress("172.20.10.2"))
        #expect(!NetworkAddressProvider.isPrivateLANAddress("198.18.0.1"))
    }
}
