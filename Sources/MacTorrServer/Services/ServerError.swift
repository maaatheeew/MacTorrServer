import Foundation

enum ServerError: LocalizedError {
    case missingServer
    case terminatedDuringLaunch

    var errorDescription: String? {
        switch self {
        case .missingServer:
            "TorrServer is missing from the app. Reinstall MacTorrServer."
        case .terminatedDuringLaunch:
            "TorrServer exited during startup. Port 8090 may already be in use."
        }
    }
}
