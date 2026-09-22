import FeatherAdmin

struct AdminEditNewsletterCampaign {
    let controller: any AdminEditNewsletterCampaignController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminEditNewsletterCampaignDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminEditNewsletterCampaignDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
