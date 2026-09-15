import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import FeatherAdmin
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
    AppEnvironmentStore.current = environment

    let webMetadataExtensions = try await buildWebMetadataExtensions()

    let router = try await buildRouter(
        environment: environment,
        referenceTypeOptions: webMetadataExtensions.referenceTypes,
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
