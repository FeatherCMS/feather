import Configuration
import SystemPackage
import Foundation
import Logging

struct MigratorConfigLoader {

    func loadMigratorConfig() async throws -> MigratorConfig {
        let reader = try await loadConfigReader(defaultFileName: "migrator")
        return try load(reader: reader)
    }

    func load(reader: ConfigReader) throws -> MigratorConfig {
        guard
            let webPublicBaseURLString = reader.string(
                forKey: "web.publicBaseURL"
            )?
            .trimmingCharacters(in: .whitespacesAndNewlines),
            !webPublicBaseURLString.isEmpty
        else {
            throw MigratorConfigurationError.missing("WEB_PUBLIC_BASE_URL")
        }
        guard
            let webPublicBaseURL = URL(string: webPublicBaseURLString),
            ["http", "https"].contains(webPublicBaseURL.scheme),
            webPublicBaseURL.host != nil
        else {
            throw MigratorConfigurationError.invalidURL("WEB_PUBLIC_BASE_URL")
        }
        return .init(
            system: loadSystemConfig(reader: reader),
            webPublicBaseURL: webPublicBaseURL,
            reset: reader.bool(
                forKey: "migrator.reset",
                default: false
            )
        )
    }
}

private func loadSystemConfig(reader: ConfigReader) -> SystemConfig {
    let logger = reader.scoped(to: "logger")
    let postgres = reader.scoped(to: "postgres")
    return .init(
        logger: .init(
            level: logger.string(
                forKey: "level",
                as: Logger.Level.self,
                default: .info
            ),
            label: logger.string(forKey: "label", default: "backend")
        ),
        database: .init(
            host: postgres.string(forKey: "host", default: "127.0.0.1"),
            port: postgres.int(forKey: "port", default: 5432),
            user: postgres.string(forKey: "user", default: "postgres"),
            password: postgres.string(forKey: "password", default: "postgres"),
            database: postgres.string(forKey: "database", default: "postgres"),
            rootCAPath: postgres.string(
                forKey: "root_ca_path",
                default: "/certs/ca.pem"
            )
        )
    )
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
