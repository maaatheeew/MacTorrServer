import Foundation
import Observation

@MainActor
@Observable
final class ServerManager {
    private enum Configuration {
        static let port = 8090
        static let supportDirectoryName = "MacTorrServer"
    }

    private(set) var status: ServerStatus = .stopped
    private(set) var errorMessage: String?
    private var process: Process?

    var endpoints: [ServerEndpoint] {
        let localEndpoint = ServerEndpoint(host: "127.0.0.1", port: Configuration.port)
        let networkEndpoints = NetworkAddressProvider.localIPv4Addresses().map {
            ServerEndpoint(host: $0, port: Configuration.port)
        }
        return [localEndpoint] + networkEndpoints
    }

    var canStart: Bool {
        status == .stopped || status == .failed
    }

    var canStop: Bool {
        status == .running || status == .starting
    }

    func start() async {
        guard canStart else { return }

        errorMessage = nil
        status = .starting

        do {
            let executableURL = try bundledExecutableURL()
            let supportDirectory = try serverDirectory()
            let newProcess = Process()
            newProcess.executableURL = executableURL
            newProcess.arguments = [
                "--port", String(Configuration.port),
                "--ip", "0.0.0.0",
                "--path", supportDirectory.appending(path: "data").path(percentEncoded: false),
                "--logpath", supportDirectory.appending(path: "torrserver.log").path(percentEncoded: false)
            ]
            newProcess.standardOutput = FileHandle.nullDevice
            newProcess.standardError = FileHandle.nullDevice
            try newProcess.run()

            process = newProcess
            try await Task.sleep(for: .milliseconds(750))

            guard newProcess.isRunning else {
                throw ServerError.terminatedDuringLaunch
            }
            status = .running
        } catch {
            process = nil
            status = .failed
            errorMessage = error.localizedDescription
        }
    }

    func stop() {
        process?.terminate()
        process = nil
        status = .stopped
        errorMessage = nil
    }

    private func bundledExecutableURL() throws -> URL {
        guard let url = Bundle.main.url(forResource: "TorrServer", withExtension: nil) else {
            throw ServerError.missingServer
        }
        return url
    }

    private func serverDirectory() throws -> URL {
        let directory = URL.applicationSupportDirectory.appending(path: Configuration.supportDirectoryName)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(
            at: directory.appending(path: "data"),
            withIntermediateDirectories: true
        )
        return directory
    }
}
