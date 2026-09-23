import FeatherAdmin

struct AdminAddNewsletterCampaign {
    let controller: any AdminAddNewsletterCampaignController

    init(apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterCampaignDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddNewsletterCampaignDefaultInteractor(
                        repository: AdminAddNewsletterCampaignOpenAPIRepository(
                            api: apiBuilder.makeNewsletterAdmin(context)
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
