import FeatherAdmin

struct AdminAddNewsletterCampaign {
    let controller: any AdminAddNewsletterCampaignController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterCampaignDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddNewsletterCampaignDefaultInteractor(
                        repository: AdminAddNewsletterCampaignOpenAPIRepository(
                            api: context.newsletterAdminAPI()
                        )
                    ),
                    presenter: AdminAddNewsletterCampaignDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
