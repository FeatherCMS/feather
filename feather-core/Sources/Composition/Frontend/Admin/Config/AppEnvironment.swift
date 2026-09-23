public import Foundation

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
