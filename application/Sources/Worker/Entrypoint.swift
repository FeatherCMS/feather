import ServiceLifecycle
import Logging
import Environment

@main
struct Entrypoint {

    static func main() async throws {
        let config = try await WorkerConfigLoader().load()
        var logger = Logger(label: config.system.logger.label)
        logger.logLevel = config.system.logger.level
        try await withLogger(logger) { _ in
            let worker = try await buildWorker(config: config)
            try await worker.run()
        }
    }
}
