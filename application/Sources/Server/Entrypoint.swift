import FeatherApplication
import Environment
import Hummingbird
import Logging

@main
struct Entrypoint {

    static func main() async throws {
        let config = try await ServerConfigLoader().load()
        var logger = Logger(label: config.system.logger.label)
        logger.logLevel = config.system.logger.level
        try await withLogger(logger) { _ in
            let server = try await buildServer(config: config)
            try await server.runService()
        }
    }
}
