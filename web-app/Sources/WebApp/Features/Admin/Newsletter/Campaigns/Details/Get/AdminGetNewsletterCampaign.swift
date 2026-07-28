import Hummingbird

struct AdminGetNewsletterCampaign {
    let controller: any AdminGetNewsletterCampaignController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminGetNewsletterCampaignDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminGetNewsletterCampaignDefaultPresenter(
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
