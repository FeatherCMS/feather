import Environment

struct MigratorConfig: Sendable {
    var system: SystemConfig
    var reset: Bool

    init(
        system: SystemConfig,
        reset: Bool
    ) {
        self.system = system
        self.reset = reset
    }
}
