import FeatherWebAdmin
import FeatherWebShared

struct AdminEditNewsletterCampaign {
    let controller: any AdminEditNewsletterCampaignController
    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminEditNewsletterCampaignDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor: AdminEditNewsletterCampaignDefaultInteractor(
                    repository: .init(
                        api: API.Client(
                            environment: environment,
                            requestContext: context
                        )
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
