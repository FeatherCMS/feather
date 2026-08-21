import Foundation

public struct AppPublicOriginConfiguration: Sendable {
    public let siteBaseURL: String
    public let staticBaseURL: String
    public let mediaBaseURL: URL

    public init(siteBaseURL: String, staticBaseURL: String, mediaBaseURL: URL) {
        self.siteBaseURL = siteBaseURL
        self.staticBaseURL = staticBaseURL
        self.mediaBaseURL = mediaBaseURL
    }

    public var usesSecureCookies: Bool {
        siteBaseURL.lowercased().hasPrefix("https://")
    }
}
