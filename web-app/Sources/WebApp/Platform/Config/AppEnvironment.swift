import Foundation

struct AppEnvironment: Sendable {
    let apiBaseURL: URL
    let publicOrigins: AppPublicOriginConfiguration
}

enum AppEnvironmentStore {
    nonisolated(unsafe) static var current = AppEnvironment(
        apiBaseURL: URL(string: "http://localhost:8080")!,
        publicOrigins: .init(
            siteBaseURL: "http://localhost:3456",
            staticBaseURL: "http://localhost:4567",
            mediaBaseURL: URL(string: "http://localhost:8080")!
        )
    )
}
