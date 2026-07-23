// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "MacTorrServer",
    platforms: [.macOS(.v26)],
    products: [
        .executable(name: "MacTorrServer", targets: ["MacTorrServer"])
    ],
    targets: [
        .executableTarget(name: "MacTorrServer"),
        .testTarget(name: "MacTorrServerTests", dependencies: ["MacTorrServer"])
    ]
)
