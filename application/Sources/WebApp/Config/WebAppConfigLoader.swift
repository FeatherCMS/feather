import Configuration
import SystemPackage
import Foundation
import Logging

struct WebAppConfigLoader {

    func load() async throws -> WebAppConfig {
        let reader = try await loadConfigReader(defaultFileName: "web-app")
        return try load(reader: reader)
    }

    func load(reader: ConfigReader) throws -> WebAppConfig {
        let turnstileKey =
            reader.string(
                forKey: "turnstile.key",
                default: ""
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let turnstileSecret =
            reader.string(
                forKey: "turnstile.secret",
                default: ""
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard turnstileKey.isEmpty == turnstileSecret.isEmpty else {
            throw TurnstileConfigurationError.incompleteCredentials
        }

        let apiBaseURLString = reader.string(
            forKey: "api.baseURL",
            default: "http://localhost:8080"
        )
        guard
            let apiBaseURL = URL(string: apiBaseURLString),
            ["http", "https"].contains(apiBaseURL.scheme),
            apiBaseURL.host != nil
        else {
            throw WebAppConfigurationError.invalidURL("API_BASE_URL")
        }

        let publicSiteBaseURLString = reader.string(
            forKey: "web.publicBaseURL",
            default: "http://localhost:3456"
        )
        guard
            let publicSiteBaseURL = URL(string: publicSiteBaseURLString),
            ["http", "https"].contains(publicSiteBaseURL.scheme),
            publicSiteBaseURL.host != nil
        else {
            throw WebAppConfigurationError.invalidURL("WEB_PUBLIC_BASE_URL")
        }

        let publicStaticBaseURLString = reader.string(
            forKey: "static.publicBaseURL",
            default: "http://localhost:4567"
        )
        guard
            let publicStaticBaseURL = URL(string: publicStaticBaseURLString),
            ["http", "https"].contains(publicStaticBaseURL.scheme),
            publicStaticBaseURL.host != nil
        else {
            throw WebAppConfigurationError.invalidURL("STATIC_PUBLIC_BASE_URL")
        }

        let publicMediaBaseURLString = reader.string(
            forKey: "media.publicBaseURL",
            default: "http://localhost:8081"
        )
        guard
            let publicMediaBaseURL = URL(string: publicMediaBaseURLString),
            ["http", "https"].contains(publicMediaBaseURL.scheme),
            publicMediaBaseURL.host != nil
        else {
            throw WebAppConfigurationError.invalidURL("MEDIA_PUBLIC_BASE_URL")
        }

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
            port: httpReader.int(forKey: "port", default: 3456),
            serverName: httpReader.string(
                forKey: "serverName",
                default: "web-app"
            ),
            loggerLabel: loggerReader.string(
                forKey: "label",
                default: "web-app"
            ),
            loggerLevel: loggerLevel,
            apiBaseURL: apiBaseURL,
            publicSiteBaseURL: publicSiteBaseURL,
            publicStaticBaseURL: publicStaticBaseURL,
            publicMediaBaseURL: publicMediaBaseURL,
            turnstileKey: turnstileKey,
            turnstileSecret: turnstileSecret
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
