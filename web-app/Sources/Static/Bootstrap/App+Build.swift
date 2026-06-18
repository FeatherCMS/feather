import Configuration
import Hummingbird
import Logging
import ServiceLifecycle

func buildApplication(
    reader: ConfigReader
) async throws -> some ApplicationProtocol {

    let logger = {
        var logger = Logger(label: "static")
        logger.logLevel = reader.string(
            forKey: "log.level",
            as: Logger.Level.self,
            default: .info
        )
        return logger
    }()

    let router = buildRouter()

    let app = Application(
        router: router,
        configuration: ApplicationConfiguration(
            reader: reader.scoped(to: "http")
        ),
        logger: logger
    )

    return app
}
