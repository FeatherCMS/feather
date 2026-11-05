import Logging

struct StaticConfig: Sendable {
    let host: String
    let port: Int
    let serverName: String
    let loggerLabel: String
    let loggerLevel: Logger.Level
}
