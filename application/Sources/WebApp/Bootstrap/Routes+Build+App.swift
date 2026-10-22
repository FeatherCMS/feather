import AccountWebApp
import ContactWebApp
import FeatherApplication
import FeatherModuleKit
import FeatherWebApp
import FeatherWebShared
import Hummingbird
import NewsletterWebApp
import WebApplication
import WebModuleWebApp

func buildAppRoutes(
    router: Hummingbird.Router<DefaultRequestContext>,
    environment: AppEnvironment,
    publicPageRenderer: any PublicPageRenderer,
    themeRenderer: DefaultThemeRenderer,
    publicContentEvents: any EventPublisher,
    apiBuilder: APIBuilder,
    mediaResolver: MediaResolver,
    publicOrigins: AppPublicOriginConfiguration
) {
    AccountWebApp.Router(
        environment: environment,
        pageRenderer: publicPageRenderer
    )
    .route(on: router)

    AppContactFormSubmission(apiBuilder: apiBuilder.contact).route(on: router)

    AppNewsletterCampaignSubscription(apiBuilder: apiBuilder.newsletterApp)
        .route(on: router)

    AppPublicContent(
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
    .controller.route(on: router)
}
