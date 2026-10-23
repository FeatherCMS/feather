import FeatherWebAdmin
import FeatherWebShared

struct AdminAddNewsletterCampaign {
    let controller: any AdminAddNewsletterCampaignController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminAddNewsletterCampaignDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminAddNewsletterCampaignDefaultInteractor(
                        repository: AdminAddNewsletterCampaignOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminAddNewsletterCampaignDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
