import Hummingbird

struct AdminGetNewsletterCampaignSubscriber {
    let controller: any AdminGetNewsletterCampaignSubscriberController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminGetNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminGetNewsletterCampaignSubscriberDefaultPresenter(
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
