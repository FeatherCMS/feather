import Hummingbird
import Logging

@main
struct Entrypoint {

    static func main() async throws {
        let config = try await WebAppConfigLoader().load()
        var logger = Logger(label: config.loggerLabel)
        logger.logLevel = config.loggerLevel
        try await withLogger(logger) { _ in
            let app = try await buildApplication(config: config)
            try await app.runService()
        }
    }
}
