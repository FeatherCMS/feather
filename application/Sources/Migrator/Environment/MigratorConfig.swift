import Environment

struct MigratorConfig: Sendable {
    var system: SystemConfig
    var webPublicBaseURL: String
    var reset: Bool

    init(
        system: SystemConfig,
        webPublicBaseURL: String,
        reset: Bool
    ) {
        self.system = system
        self.webPublicBaseURL = webPublicBaseURL
        self.reset = reset
    }
}
