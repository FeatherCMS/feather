import Hummingbird

struct AdminRemoveNewsletterCampaignSubscriber {
    let controller: any AdminRemoveNewsletterCampaignSubscriberController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminRemoveNewsletterCampaignSubscriberDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }
    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
