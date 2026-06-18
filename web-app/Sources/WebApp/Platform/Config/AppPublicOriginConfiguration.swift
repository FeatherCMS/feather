import Foundation

struct AppPublicOriginConfiguration: Sendable {
    let siteBaseURL: String
    let staticBaseURL: String
    let mediaBaseURL: URL

    var usesSecureCookies: Bool {
        siteBaseURL.lowercased().hasPrefix("https://")
    }
}
