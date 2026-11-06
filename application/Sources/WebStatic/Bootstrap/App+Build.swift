import Hummingbird
import Logging

func buildApplication(
    config: WebStaticConfig
) async throws -> some ApplicationProtocol {

    let router = buildRouter()

    let app = Application(
        router: router,
        configuration: ApplicationConfiguration(
            address: .hostname(config.host, port: config.port),
            serverName: config.serverName
        ),
        logger: Logger.current
    )

    return app
}
