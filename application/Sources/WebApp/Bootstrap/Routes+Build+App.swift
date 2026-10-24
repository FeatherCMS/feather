import AccountWebApp
import ContactWebApp
import ContactModule
import FeatherApplication
import FeatherModuleKit
import FeatherWebApp
import FeatherWebShared
import Hummingbird
import NewsletterWebApp
import NewsletterModule
import WebApplication
import WebModuleWebApp

func buildAppRoutes(
    router: Hummingbird.Router<DefaultRequestContext>,
    environment: AppEnvironment,
    publicPageRenderer: any PublicPageRenderer,
    themeRenderer: DefaultThemeRenderer,
    publicContentEvents: any EventPublisher,
    mediaResolver: MediaResolver,
    publicOrigins: AppPublicOriginConfiguration
) {
    AccountWebApp.Router(
        environment: environment,
        pageRenderer: publicPageRenderer
    )
    .route(on: router)

    Submission.Router(environment: environment).route(on: router)

    Campaign.Subscription.Router(environment: environment)
        .route(on: router)

    Public.Content
        .Router(
            events: publicContentEvents,
            themeRenderer: themeRenderer,
            contentRenderer: DefaultMarkdownRenderer(
                events: publicContentEvents,
                mediaResolver: mediaResolver
            ),
            apiBaseURL: environment.apiBaseURL,
            publicOrigins: publicOrigins,
            mediaResolver: mediaResolver
        )
        .route(on: router)
}
