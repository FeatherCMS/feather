import FeatherAdmin

struct AdminListNewsletterCampaigns {
    let controller: any AdminListNewsletterCampaignsController

    init(
        apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminListNewsletterCampaignsDefaultController {
            request,
            context in
            (
                AdminListNewsletterCampaignsDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
                ),
                AdminListNewsletterCampaignsDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
