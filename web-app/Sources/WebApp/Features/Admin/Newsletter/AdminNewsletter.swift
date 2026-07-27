import Hummingbird

struct AdminNewsletter {
    let renderingEngine: any RenderingEngine

    func route(on router: Router<AppRequestContext>) {
        let newsletters = AdminManageNewsletters(
            renderingEngine: renderingEngine
        )
        .controller
        AdminListNewsletters(controller: newsletters).route(on: router)
        AdminBulkRemoveNewsletters(controller: newsletters).route(on: router)
        AdminEditNewsletter(controller: newsletters).route(on: router)
        AdminRemoveNewsletter(controller: newsletters).route(on: router)

        AdminAddNewsletter(
            controller: AdminAddContactNewsletter(
                renderingEngine: renderingEngine
            )
            .controller
        )
        .route(on: router)

        AdminListNewsletterIssues(
            controller: AdminNewsletterIssueList(
                renderingEngine: renderingEngine
            )
            .controller
        )
        .route(on: router)
        AdminAddNewsletterIssue(
            controller: AdminAddContactNewsletterIssue(
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

        let subscribers = AdminManageNewsletterSubscribers(
            renderingEngine: renderingEngine
        )
        .controller
        AdminListNewsletterSubscribers(controller: subscribers)
            .route(on: router)
        AdminAddNewsletterCampaignSubscriber(controller: subscribers)
            .route(on: router)
        AdminEditNewsletterCampaignSubscriber(controller: subscribers)
            .route(on: router)
        AdminRemoveNewsletterCampaignSubscriber(controller: subscribers)
            .route(on: router)
        AdminBulkRemoveNewsletterSubscribers(controller: subscribers)
            .route(on: router)

        AdminNewsletterSubscribersDirectory(renderingEngine: renderingEngine)
            .controller.route(on: router)
        AdminAddNewsletterSubscriber(renderingEngine: renderingEngine)
            .controller.route(on: router)
    }
}
