import Hummingbird

struct AdminListNewsletterCampaigns {
    let controller: any AdminListNewsletterCampaignsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListNewsletterCampaignsDefaultController {
            request,
            context in
            (
                AdminListNewsletterCampaignsDefaultInteractor(
                    repository: .init(api: context.managementAPI())
                ),
                AdminListNewsletterCampaignsDefaultPresenter(
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
