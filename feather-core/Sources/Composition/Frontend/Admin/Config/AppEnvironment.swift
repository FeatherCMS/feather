import Foundation

public struct AppEnvironment: Sendable {
    public let apiBaseURL: URL
    public let publicOrigins: AppPublicOriginConfiguration

    public init(
        apiBaseURL: URL,
        publicOrigins: AppPublicOriginConfiguration
    ) {
        self.apiBaseURL = apiBaseURL
        self.publicOrigins = publicOrigins
    }
}

public enum AppEnvironmentStore {
    public nonisolated(unsafe) static var current = AppEnvironment(
        apiBaseURL: URL(string: "http://localhost:8080")!,
        publicOrigins: .init(
            siteBaseURL: "http://localhost:3456",
            staticBaseURL: "http://localhost:4567",
            mediaBaseURL: URL(string: "http://localhost:8080")!
        )
    )
}
