import FeatherWebShared
import MediaWebAdmin
import ContactWebAdmin
import NewsletterWebAdmin
import NewsletterWebApp
import WebModuleWebAdmin
import AnalyticsWebApp
import RedirectWebAdmin
import UserWebAdmin
import SystemWebAdmin
import FeatherWebAdmin
import Foundation
import Hummingbird
import Logging
import ServiceLifecycle

func buildApplication(
    config: WebAppConfig
) async throws -> some ApplicationProtocol {
    let turnstileVerifier =
        config.turnstileKey.isEmpty
        ? nil
        : CloudflareTurnstileVerifier(
            siteKey: config.turnstileKey,
            secretKey: config.turnstileSecret
        )
    let environment = AppEnvironment(
        apiBaseURL: config.apiBaseURL,
        publicOrigins: .init(
            siteBaseURL: config.publicSiteBaseURL.absoluteString,
            staticBaseURL: config.publicStaticBaseURL.absoluteString,
            mediaBaseURL: config.publicMediaBaseURL
        )
    )
    let webMetadataExtensions = try await buildWebMetadataExtensions()

    let router = try await buildRouter(
        environment: environment,
        templateOptions: webMetadataExtensions.templates,
        templateDefinitions: webMetadataExtensions.templateDefinitions,
        templatePaths: webMetadataExtensions.templatePaths,
        turnstileVerifier: turnstileVerifier
    )

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
