import Logging

public struct SystemConfig: Sendable {

    public struct DatabaseConfig: Sendable {
        public let host: String
        public let port: Int
        public let user: String
        public let password: String
        public let database: String
        public let rootCAPath: String

        public init(
            host: String,
            port: Int,
            user: String,
            password: String,
            database: String,
            rootCAPath: String
        ) {
            self.host = host
            self.port = port
            self.user = user
            self.password = password
            self.database = database
            self.rootCAPath = rootCAPath
        }
    }

    public struct LoggerConfig: Sendable {
        public let level: Logger.Level
        public let label: String

        public init(
            level: Logger.Level,
            label: String
        ) {
            self.level = level
            self.label = label
        }
    }

    public let logger: LoggerConfig
    public let database: DatabaseConfig

    public init(
        logger: LoggerConfig,
        database: DatabaseConfig,
    ) {
        self.logger = logger
        self.database = database
    }
}
