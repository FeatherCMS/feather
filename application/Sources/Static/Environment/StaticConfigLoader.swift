import Configuration
import Environment
import Logging

struct StaticConfigLoader {

    let environmentLoader: EnvironmentLoader

    init(environmentLoader: EnvironmentLoader = .init()) {
        self.environmentLoader = environmentLoader
    }

    func load() async throws -> StaticConfig {
        let reader = try await environmentLoader.loadConfigReader(
            defaultEnvironmentFilePrefix: "static"
        )
        return load(reader: reader)
    }

    func load(reader: ConfigReader) -> StaticConfig {
        let loggerReader = reader.scoped(to: "logger")
        let httpReader = reader.scoped(to: "http")
        let loggerLevel = loggerReader.string(
            forKey: "level",
            as: Logger.Level.self,
            default: reader.string(
                forKey: "log.level",
                as: Logger.Level.self,
                default: .info
            )
        )

        return .init(
            host: httpReader.string(forKey: "host", default: "0.0.0.0"),
            port: httpReader.int(forKey: "port", default: 4567),
            serverName: httpReader.string(
                forKey: "serverName",
                default: "static"
            ),
            loggerLabel: loggerReader.string(
                forKey: "label",
                default: "static"
            ),
            loggerLevel: loggerLevel
        )
    }
}
