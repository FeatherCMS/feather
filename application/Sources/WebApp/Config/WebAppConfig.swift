import Foundation
import Logging

struct WebAppConfig: Sendable {
    let host: String
    let port: Int
    let serverName: String
    let loggerLabel: String
    let loggerLevel: Logger.Level
    let apiBaseURL: URL
    let publicSiteBaseURL: URL
    let publicStaticBaseURL: URL
    let publicMediaBaseURL: URL
    let turnstileKey: String
    let turnstileSecret: String
}
