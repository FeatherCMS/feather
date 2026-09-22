import FeatherAdmin

struct AdminListNewsletterCampaigns {
    let controller: any AdminListNewsletterCampaignsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListNewsletterCampaignsDefaultController {
            request,
            context in
            (
                AdminListNewsletterCampaignsDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
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
