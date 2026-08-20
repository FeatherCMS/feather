import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

public struct AdminNewsletter {
    let renderingEngine: any RenderingEngine


    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public func route(on router: Router<AppRequestContext>) {
        AdminListNewsletterCampaigns(renderingEngine: renderingEngine)
            .route(on: router)
        AdminGetNewsletterCampaign(renderingEngine: renderingEngine)
            .route(on: router)
        AdminEditNewsletterCampaign(renderingEngine: renderingEngine)
            .route(on: router)
        AdminRemoveNewsletterCampaign(renderingEngine: renderingEngine)
            .route(on: router)

        AdminAddNewsletterCampaign(renderingEngine: renderingEngine)
            .route(on: router)

        AdminListNewsletterIssues(renderingEngine: renderingEngine)
            .route(on: router)
        AdminGetNewsletterIssue(renderingEngine: renderingEngine)
            .route(on: router)
        AdminAddNewsletterIssue(
            controller: AdminAddNewsletterIssueComponent(
                renderingEngine: renderingEngine
            )
            .controller
        )
        .route(on: router)
        AdminEditNewsletterIssue(renderingEngine: renderingEngine)
            .route(on: router)
        AdminRemoveNewsletterIssue(renderingEngine: renderingEngine)
            .route(on: router)
        AdminTestNewsletterIssueEmail().route(on: router)

        AdminListNewsletterSubscribers(renderingEngine: renderingEngine)
            .route(on: router)
        AdminAddNewsletterSubscriber(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminRemoveNewsletterSubscribers(renderingEngine: renderingEngine)
            .route(on: router)
    }
}
