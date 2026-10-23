import FeatherWebAdmin

struct AdminEditNewsletterCampaign {
    let controller: any AdminEditNewsletterCampaignController
    init(
        apiBuilder: NewsletterAdminAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminEditNewsletterCampaignDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor: AdminEditNewsletterCampaignDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
                ),
                presenter: AdminEditNewsletterCampaignDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
