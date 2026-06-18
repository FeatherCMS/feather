import Configuration
import Environment

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
        return .init(
            system: systemConfigLoader.load(
                reader: reader
            ),
            reset: reader.bool(
                forKey: "migrator.reset",
                default: false
            )
        )
    }
}
