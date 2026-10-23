import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignSubscriber {
    let controller: any AdminViewNewsletterCampaignSubscriberController
    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminViewNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor:
                    AdminViewNewsletterCampaignSubscriberDefaultInteractor(
                        repository: .init(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                presenter:
                    AdminViewNewsletterCampaignSubscriberDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
            )
        }
    }
}
