import Environment
import Foundation

struct MigratorConfig: Sendable {
    var system: SystemConfig
    var webPublicBaseURL: URL
    var reset: Bool

    init(
        system: SystemConfig,
        webPublicBaseURL: URL,
        reset: Bool
    ) {
        self.system = system
        self.webPublicBaseURL = webPublicBaseURL
        self.reset = reset
    }
}
