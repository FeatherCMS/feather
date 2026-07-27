import Hummingbird

struct AdminAddNewsletterCampaign {
    let controller: any AdminAddNewsletterCampaignController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterCampaignDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddNewsletterCampaignDefaultInteractor(
                        repository: AdminAddNewsletterCampaignOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminAddNewsletterCampaignDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
