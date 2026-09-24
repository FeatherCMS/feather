import Foundation
import FeatherContracts
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
import FeatherApplication
import Hummingbird
import WebApplication
import NewsFrontend

func buildAppRoutes(
    router: Router<DefaultRequestContext>,
    authRouter: Router<DefaultRequestContext>,
    renderingEngine: DefaultRenderingEngine,
    themeRenderer: DefaultThemeRenderer,
    publicContentEvents: any EventPublisher,
    apiBuilder: APIBuilder,
    mediaResolver: MediaResolver,
    publicOrigins: AppPublicOriginConfiguration
) {
    AppContactFormSubmission(apiBuilder: apiBuilder.contact).route(on: router)

    AppNewsletterCampaignSubscription(apiBuilder: apiBuilder.newsletter)
        .route(on: router)

    AppPublicContent(
        events: publicContentEvents,
        themeRenderer: themeRenderer,
        contentRenderer: DefaultMarkdownRenderer(
            events: publicContentEvents,
            mediaResolver: mediaResolver
        ),
        webAPIBuilder: apiBuilder.web,
        publicOrigins: publicOrigins,
        mediaResolver: mediaResolver
    )
    .controller.route(on: router)

}
