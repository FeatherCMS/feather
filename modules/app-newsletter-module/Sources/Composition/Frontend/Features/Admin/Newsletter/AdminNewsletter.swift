import FeatherAdmin
import Hummingbird

public struct AdminNewsletter {
    public let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public func route(on router: Router<DefaultRequestContext>) {
        AdminViewNewsletterOverview(renderingEngine: renderingEngine)
            .controller.route(on: router)

        AdminListNewsletterCampaigns(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminGetNewsletterCampaign(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminEditNewsletterCampaign(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminRemoveNewsletterCampaign(renderingEngine: renderingEngine)
            .controller.route(on: router)

        AdminAddNewsletterCampaign(renderingEngine: renderingEngine)
            .controller.route(on: router)

        AdminListNewsletterIssues(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminGetNewsletterIssue(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminAddNewsletterIssue(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminEditNewsletterIssue(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminRemoveNewsletterIssue(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminTestNewsletterIssueEmail().controller.route(on: router)

        AdminListNewsletterSubscribers(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminAddNewsletterSubscriber(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminRemoveNewsletterSubscribers(renderingEngine: renderingEngine)
            .controller.route(on: router)
    }
}
