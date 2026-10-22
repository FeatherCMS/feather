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
            (
                AdminRemoveNewsletterCampaignDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
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
