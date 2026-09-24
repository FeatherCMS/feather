public import FeatherAdmin
public import Hummingbird

public struct AdminNewsletter {
    private let apiBuilder: NewsletterAPIBuilder
    public let renderingEngine: any RenderingEngine

    public init(
        apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
    }

    public func route(on router: any RouterMethods<AuthenticatedRequestContext>)
    {
        AdminViewNewsletterOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListNewsletterCampaigns(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminViewNewsletterCampaign(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminEditNewsletterCampaign(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminRemoveNewsletterCampaign(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddNewsletterCampaign(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListNewsletterIssues(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminViewNewsletterIssue(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminAddNewsletterIssue(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminEditNewsletterIssue(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminRemoveNewsletterIssue(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminTestNewsletterIssueEmail(apiBuilder: apiBuilder).controller
            .route(on: router)

        AdminViewNewsletterCampaignSubscriber(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminListNewsletterCampaignSubscribers(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminListNewsletterSubscribers(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminAddNewsletterSubscriber(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
        AdminRemoveNewsletterSubscribers(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
