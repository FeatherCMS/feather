import FeatherWebAdmin

struct AdminListNewsletterCampaigns {
    let controller: any AdminListNewsletterCampaignsController

    init(
        apiBuilder: NewsletterAdminAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminListNewsletterCampaignsDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor: AdminListNewsletterCampaignsDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
                ),
                presenter: AdminListNewsletterCampaignsDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
