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
    publicContentRepository: any AppPublicContentRepository,
    publicContentEvents: any EventPublisher
) {
    AppContactFormSubmission().route(on: router)

    AppNewsletterCampaignSubscription()
        .route(on: router)

    AppPublicContent(
        repository: publicContentRepository,
        events: publicContentEvents,
        themeRenderer: themeRenderer,
        contentRenderer: DefaultMarkdownRenderer(
            events: publicContentEvents,
            mediaBaseURL: AppEnvironmentStore.current.publicOrigins
                .mediaBaseURL.absoluteString
        )
    )
    .controller.route(on: router)

}
