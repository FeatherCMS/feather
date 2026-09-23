import FeatherAdmin

struct AdminEditNewsletterCampaign {
    let controller: any AdminEditNewsletterCampaignController
    init(apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminEditNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminEditNewsletterCampaignDefaultInteractor(
                    repository: .init(api: apiBuilder.makeNewsletterAdmin(context))
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
