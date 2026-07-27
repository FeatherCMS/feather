import Hummingbird

struct AdminNewsletter {
    let renderingEngine: any RenderingEngine

    func route(on router: Router<AppRequestContext>) {
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

        AdminListNewsletterCampaignSubscribers(renderingEngine: renderingEngine)
            .route(on: router)
        AdminAddNewsletterCampaignSubscriber(renderingEngine: renderingEngine)
            .route(on: router)
        AdminGetNewsletterCampaignSubscriber(renderingEngine: renderingEngine)
            .route(on: router)
        AdminEditNewsletterCampaignSubscriber(renderingEngine: renderingEngine)
            .route(on: router)
        AdminRemoveNewsletterCampaignSubscriber(
            renderingEngine: renderingEngine
        )
        .route(on: router)

        AdminListNewsletterSubscribers(renderingEngine: renderingEngine)
            .route(on: router)
        AdminAddNewsletterSubscriber(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminGetNewsletterSubscriber(renderingEngine: renderingEngine)
            .route(on: router)
        AdminEditNewsletterSubscriber(renderingEngine: renderingEngine)
            .route(on: router)
        AdminRemoveNewsletterSubscribers(renderingEngine: renderingEngine)
            .route(on: router)
    }
}
