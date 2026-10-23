import FeatherWebAdmin

struct AdminRemoveNewsletterCampaign {
    let controller: any AdminRemoveNewsletterCampaignController
    init(
        apiBuilder: NewsletterAdminAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminRemoveNewsletterCampaignDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor: AdminRemoveNewsletterCampaignDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
                ),
                presenter: AdminRemoveNewsletterCampaignDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
