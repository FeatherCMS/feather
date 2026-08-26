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
import WebStandards
import WebApplication
import NewsFrontend

func buildAppRoutes(
    router: Router<AppRequestContext>,
    authRouter: Router<AppRequestContext>,
    renderingEngine: DefaultRenderingEngine,
    themeRenderer: ThemeRenderer,
    publicContentRepository: any AppPublicContentRepository,
    publicContentEvents: any EventPublisher,
    styleshetCollector: GlobalStylesheetCollector
) {
    AppContactFormSubmission().route(on: router)

    AppNewsletterCampaignSubscription()
        .route(on: router)

    AppGetStylesheet(
        globalStylesheetCollector: styleshetCollector
    )
    .route(on: router)

    AppPublicContent(
        repository: publicContentRepository,
        events: publicContentEvents,
        themeRenderer: themeRenderer,
        contentRenderer: MarkdownContentRenderer(
            events: publicContentEvents,
            mediaBaseURL: AppEnvironmentStore.current.publicOrigins
                .mediaBaseURL.absoluteString
        )
    )
    .controller.route(on: router)

}
import Foundation
