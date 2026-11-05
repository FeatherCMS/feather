import Configuration
import SystemPackage
import Logging

struct StaticConfigLoader {

    func load() async throws -> StaticConfig {
        let reader = try await loadConfigReader(defaultFileName: "static")
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

private func loadConfigReader(
    defaultFileName: String
) async throws -> ConfigReader {
    let arguments = ConfigReader(providers: [CommandLineArgumentsProvider()])
    let environment = arguments.string(forKey: "env", default: "dev")
        .lowercased()
    let filePath = arguments.string(forKey: "env.filePath")
    var providers: [any ConfigProvider] = [EnvironmentVariablesProvider()]
    if let filePath {
        providers.append(
            try await EnvironmentVariablesProvider(
                environmentFilePath: .init(filePath),
                allowMissing: false
            )
        )
    }
    else {
        providers.append(
            try await EnvironmentVariablesProvider(
                environmentFilePath: .init(
                    "\(defaultFileName).\(environment).env"
                ),
                allowMissing: true
            )
        )
    }
    return ConfigReader(providers: providers)
}
