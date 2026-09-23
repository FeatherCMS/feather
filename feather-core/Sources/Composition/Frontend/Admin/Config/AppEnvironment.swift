public import FeatherContracts
public import Foundation

public struct AppEnvironment: Sendable {
    public let apiBaseURL: URL
    public let publicOrigins: AppPublicOriginConfiguration
    public let mediaResolver: MediaResolver

    public init(
        apiBaseURL: URL,
        publicOrigins: AppPublicOriginConfiguration
    ) {
        self.apiBaseURL = apiBaseURL
        self.publicOrigins = publicOrigins
        self.mediaResolver = MediaResolver(
            mediaBaseURL: publicOrigins.mediaBaseURL
        )
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
