import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaign {
    let controller: any AdminViewNewsletterCampaignController
    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminViewNewsletterCampaignDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor: AdminViewNewsletterCampaignDefaultInteractor(
                    repository: .init(
                        api: API.Client(
                            environment: environment,
                            requestContext: context
                        )
                    )
                ),
                presenter: AdminViewNewsletterCampaignDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
