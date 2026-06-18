import Configuration
import SystemPackage

public struct EnvironmentLoader {
    public let environment: BuildEnvironment
    public let envFilePath: String?

    public init() {
        let preReader = ConfigReader(
            providers: [
                CommandLineArgumentsProvider()
            ]
        )
        self.environment =
            BuildEnvironment(
                rawValue:
                    preReader.string(
                        forKey: "env",
                        default: BuildEnvironment.dev.rawValue
                    )
                    .lowercased()
            ) ?? .dev
        self.envFilePath = preReader.string(forKey: "env.filePath")
    }

    public func loadConfigReader(
        defaultEnvironmentFilePrefix: String
    ) async throws -> ConfigReader {
        var providers: [ConfigProvider] = [
            EnvironmentVariablesProvider()
        ]
        if let configFilePath = envFilePath {
            providers.append(
                try await EnvironmentVariablesProvider(
                    environmentFilePath: .init(configFilePath),
                    allowMissing: false
                )
            )
        }
        else {
            providers.append(
                try await EnvironmentVariablesProvider(
                    environmentFilePath: .init(
                        "\(defaultEnvironmentFilePrefix).\(environment.rawValue).env"
                    ),
                    allowMissing: true
                )
            )
        }

        return ConfigReader(providers: providers)
    }
}
