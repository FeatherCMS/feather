import Configuration
import Hummingbird
import Logging
import ServiceLifecycle

func buildApplication(
    reader: ConfigReader
) async throws -> some ApplicationProtocol {

    let router = buildRouter()

    let app = Application(
        router: router,
        configuration: ApplicationConfiguration(
            reader: reader.scoped(to: "http")
        ),
        logger: Logger.current
    )

    return app
}
