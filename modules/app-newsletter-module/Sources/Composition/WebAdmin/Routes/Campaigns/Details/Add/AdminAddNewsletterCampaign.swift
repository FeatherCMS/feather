import FeatherWebAdmin

struct AdminAddNewsletterCampaign {
    let controller: any AdminAddNewsletterCampaignController

    init(
        apiBuilder: NewsletterAdminAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminAddNewsletterCampaignDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
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
