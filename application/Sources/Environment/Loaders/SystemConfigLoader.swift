import Configuration
import Logging

public struct SystemConfigLoader {
    public init() {}

    public func load(
        reader: ConfigReader
    ) -> SystemConfig {

        let loggerScope = reader.scoped(to: "logger")
        let postgresScope = reader.scoped(to: "postgres")

        return .init(
            logger: .init(
                level: loggerScope.string(
                    forKey: "level",
                    as: Logger.Level.self,
                    default: .info
                ),
                label: loggerScope.string(
                    forKey: "label",
                    default: "backend"
                )
            ),
            database: .init(
                host: postgresScope.string(
                    forKey: "host",
                    default: "127.0.0.1"
                ),
                port: postgresScope.int(
                    forKey: "port",
                    default: 5432
                ),
                user: postgresScope.string(
                    forKey: "user",
                    default: "postgres"
                ),
                password: postgresScope.string(
                    forKey: "password",
                    default: "postgres"
                ),
                database: postgresScope.string(
                    forKey: "database",
                    default: "postgres"
                ),
                rootCAPath: postgresScope.string(
                    forKey: "root_ca_path",
                    default: "/certs/ca.pem"
                )
            ),
        )
    }
}
