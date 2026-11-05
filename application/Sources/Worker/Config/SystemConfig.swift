import Logging

struct SystemConfig: Sendable {
    struct DatabaseConfig: Sendable {
        let host: String
        let port: Int
        let user: String
        let password: String
        let database: String
        let rootCAPath: String
    }

    struct LoggerConfig: Sendable {
        let level: Logger.Level
        let label: String
    }

    let logger: LoggerConfig
    let database: DatabaseConfig
}
