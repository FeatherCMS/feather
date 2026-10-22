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
            (
                AdminEditNewsletterCampaignDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
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
