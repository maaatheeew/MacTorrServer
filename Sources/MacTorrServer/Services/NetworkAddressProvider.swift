import Darwin
import Foundation

enum NetworkAddressProvider {
    static func localIPv4Addresses() -> [String] {
        var interfaces: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&interfaces) == 0, let interfaces else { return [] }
        defer { freeifaddrs(interfaces) }

        var addresses = Set<String>()
        var current: UnsafeMutablePointer<ifaddrs>? = interfaces

        while let interface = current {
            defer { current = interface.pointee.ifa_next }
            guard
                let address = interface.pointee.ifa_addr,
                address.pointee.sa_family == UInt8(AF_INET),
                (interface.pointee.ifa_flags & UInt32(IFF_UP)) != 0,
                (interface.pointee.ifa_flags & UInt32(IFF_LOOPBACK)) == 0
            else { continue }

            var host = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            guard getnameinfo(
                address,
                socklen_t(address.pointee.sa_len),
                &host,
                socklen_t(host.count),
                nil,
                0,
                NI_NUMERICHOST
            ) == 0 else { continue }

            let octets = host.prefix { $0 != 0 }.map { UInt8(bitPattern: $0) }
            let hostAddress = String(decoding: octets, as: UTF8.self)
            if isPrivateLANAddress(hostAddress) {
                addresses.insert(hostAddress)
            }
        }

        return addresses.sorted()
    }

    static func isPrivateLANAddress(_ address: String) -> Bool {
        let octets = address.split(separator: ".").compactMap { Int($0) }
        guard octets.count == 4 else { return false }

        let first = octets[0]
        let second = octets[1]
        return first == 10
            || (first == 192 && second == 168)
            || (first == 172 && (16...31).contains(second))
    }
}
