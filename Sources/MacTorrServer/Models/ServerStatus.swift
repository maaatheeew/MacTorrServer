import Foundation

enum ServerStatus: Equatable {
    case stopped
    case starting
    case running
    case failed

    var title: String {
        switch self {
        case .stopped: "Server Stopped"
        case .starting: "Starting Server"
        case .running: "Server Running"
        case .failed: "Server Failed to Start"
        }
    }

    var systemImage: String {
        switch self {
        case .stopped: "stop.circle"
        case .starting: "arrow.triangle.2.circlepath"
        case .running: "checkmark.circle.fill"
        case .failed: "exclamationmark.triangle.fill"
        }
    }
}
