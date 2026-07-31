import Hummingbird

struct AdminAddNewsletterCampaignSubscriber {
    let controller: any AdminAddNewsletterCampaignSubscriberController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminAddNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminAddNewsletterCampaignSubscriberDefaultPresenter(
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
