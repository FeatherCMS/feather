import Hummingbird

struct AdminListNewsletterCampaignSubscribers {
    let controller: any AdminListNewsletterCampaignSubscribersController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminListNewsletterCampaignSubscribersDefaultController {
            request,
            context in
            (
                AdminListNewsletterCampaignSubscribersDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminListNewsletterCampaignSubscribersDefaultPresenter(
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
