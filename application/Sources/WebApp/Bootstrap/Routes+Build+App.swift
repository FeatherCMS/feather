import Foundation
import FeatherModuleKit
import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserWebAdmin
import SystemWebAdmin
import FeatherWebAdmin
import FeatherApplication
import Hummingbird
import WebApplication
import NewsFrontend

func buildAppRoutes(
    router: Hummingbird.Router<DefaultRequestContext>,
    authRouter: Hummingbird.Router<DefaultRequestContext>,
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
        apiBaseURL: apiBuilder.web.baseURL,
        publicOrigins: publicOrigins,
        mediaResolver: mediaResolver
    )
    .controller.route(on: router)

}
