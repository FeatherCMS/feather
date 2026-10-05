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
        guard
            let webPublicBaseURL = reader.string(
                forKey: "web.publicBaseURL"
            )?.trimmingCharacters(in: .whitespacesAndNewlines),
            !webPublicBaseURL.isEmpty
        else {
            throw MigratorConfigurationError.missing("WEB_PUBLIC_BASE_URL")
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
