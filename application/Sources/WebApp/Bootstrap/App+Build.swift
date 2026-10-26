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
import Configuration
import Foundation
import Hummingbird
import Logging
import ServiceLifecycle

func buildApplication(
    reader: ConfigReader
) async throws -> some ApplicationProtocol {
    let urlResolver = AppEnvironmentURLResolver(reader: reader)
    let turnstileKey = reader.string(
        forKey: "turnstile.key",
        default: ""
    ).trimmingCharacters(in: .whitespacesAndNewlines)
    let turnstileSecret = reader.string(
        forKey: "turnstile.secret",
        default: ""
    ).trimmingCharacters(in: .whitespacesAndNewlines)
    guard turnstileKey.isEmpty == turnstileSecret.isEmpty else {
        throw TurnstileConfigurationError.incompleteCredentials
    }
    let turnstileVerifier =
        turnstileKey.isEmpty
        ? nil
        : CloudflareTurnstileVerifier(
            siteKey: turnstileKey,
            secretKey: turnstileSecret
        )
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
        templatePaths: webMetadataExtensions.templatePaths,
        turnstileVerifier: turnstileVerifier
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
