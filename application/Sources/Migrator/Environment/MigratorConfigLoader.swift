import Configuration
import Environment
import Foundation

struct MigratorConfigLoader {

    private let environmentLoader: EnvironmentLoader
    private let systemConfigLoader: SystemConfigLoader

    init(
        environmentLoader: EnvironmentLoader = .init(),
        systemConfigLoader: SystemConfigLoader = .init()
    ) {
        self.environmentLoader = environmentLoader
        self.systemConfigLoader = systemConfigLoader
    }

    func loadMigratorConfig() async throws -> MigratorConfig {
        let reader = try await environmentLoader.loadConfigReader(
            defaultEnvironmentFilePrefix: "migrator"
        )
        return try load(reader: reader)
    }

    func load(reader: ConfigReader) throws -> MigratorConfig {
        guard let webPublicBaseURLString = reader.string(
            forKey: "web.publicBaseURL"
        )?.trimmingCharacters(in: .whitespacesAndNewlines),
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
            system: systemConfigLoader.load(
                reader: reader
            ),
            webPublicBaseURL: webPublicBaseURL,
            reset: reader.bool(
                forKey: "migrator.reset",
                default: false
            )
        )
    }
}
