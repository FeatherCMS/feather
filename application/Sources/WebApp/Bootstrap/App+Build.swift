import BlogFrontend
import FeatherWebShared
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectWebAdmin
import UserWebAdmin
import SystemWebAdmin
import FeatherWebAdmin
import Configuration
import Foundation
import Hummingbird
import Logging
import ServiceLifecycle

func buildApplication(
    reader: ConfigReader
) async throws -> some ApplicationProtocol {
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
    let webMetadataExtensions = try await buildWebMetadataExtensions()

    let router = try await buildRouter(
        environment: environment,
        templateOptions: webMetadataExtensions.templates,
        templateDefinitions: webMetadataExtensions.templateDefinitions,
        templatePaths: webMetadataExtensions.templatePaths
    )

    let app = Application(
        router: router,
        configuration: ApplicationConfiguration(
            reader: reader.scoped(to: "http")
        ),
        logger: Logger.current
    )

    return app
}
