import CSS
import Configuration
import Foundation
import Hummingbird
import Logging
import ServiceLifecycle
import WebStandards

func buildApplication(
    reader: ConfigReader
) async throws -> some ApplicationProtocol {

    let logger = {
        var logger = Logger(label: "web-app")
        logger.logLevel = reader.string(
            forKey: "log.level",
            as: Logger.Level.self,
            default: .info
        )
        return logger
    }()

    let urlResolver = AppEnvironmentURLResolver(reader: reader)
    let environment = AppEnvironment(
        apiBaseURL: URL(
            string: urlResolver.apiBaseURL()
        )!,
        publicOrigins: .init(
            siteBaseURL: urlResolver.publicSiteBaseURL(),
            staticBaseURL: urlResolver.publicStaticBaseURL(),
            mediaBaseURL: URL(
                string: urlResolver.publicMediaBaseURL()
            )!
        )
    )
    AppEnvironmentStore.current = environment

    var styleshetCollector = GlobalStylesheetCollector()

    // list all global css components
    styleshetCollector.register(CSS.ModernNormalize.self)
    styleshetCollector.register(CSS.ModernBase.self)
    styleshetCollector.register(CSS.Grid.self)
    styleshetCollector.register(CSS.Base.self)

    let router = buildRouter(
        logger: logger,
        styleshetCollector: styleshetCollector,
        environment: environment
    )

    let app = Application(
        router: router,
        configuration: ApplicationConfiguration(
            reader: reader.scoped(to: "http")
        ),
        logger: logger
    )

    return app
}
