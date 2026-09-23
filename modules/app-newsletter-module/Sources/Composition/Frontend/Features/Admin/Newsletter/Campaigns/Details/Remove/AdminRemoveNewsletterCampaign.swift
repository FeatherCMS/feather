import FeatherAdmin

struct AdminRemoveNewsletterCampaign {
    let controller: any AdminRemoveNewsletterCampaignController
    init(apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterCampaignDefaultInteractor(
                    repository: .init(api: apiBuilder.makeNewsletterAdmin(context))
                ),
                AdminRemoveNewsletterCampaignDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
