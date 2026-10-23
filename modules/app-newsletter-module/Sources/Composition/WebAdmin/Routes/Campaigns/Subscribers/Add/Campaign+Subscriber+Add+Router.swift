import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterCampaignSubscriber {
    let controller: any AdminAddNewsletterCampaignSubscriberController
    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminAddNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor:
                    AdminAddNewsletterCampaignSubscriberDefaultInteractor(
                        repository: .init(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                presenter: AdminAddNewsletterCampaignSubscriberDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
