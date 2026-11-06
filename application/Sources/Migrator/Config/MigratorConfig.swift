import Foundation
import Logging

struct MigratorConfig: Sendable {
    enum Error: Swift.Error {
        case missing(String)
        case invalidURL(String)
    }

    struct System: Sendable {
        struct Database: Sendable {
            let host: String
            let port: Int
            let user: String
            let password: String
            let database: String
            let rootCAPath: String
        }

        struct Logger: Sendable {
            let level: Logging.Logger.Level
            let label: String
        }

        let logger: Logger
        let database: Database
    }

    let system: System
    let webPublicBaseURL: URL
    let reset: Bool
}
