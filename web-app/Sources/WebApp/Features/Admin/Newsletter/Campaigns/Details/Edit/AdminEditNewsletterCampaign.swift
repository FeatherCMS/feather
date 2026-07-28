import Hummingbird

struct AdminEditNewsletterCampaign {
    let controller: any AdminEditNewsletterCampaignController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminEditNewsletterCampaignDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminEditNewsletterCampaignDefaultPresenter(
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
