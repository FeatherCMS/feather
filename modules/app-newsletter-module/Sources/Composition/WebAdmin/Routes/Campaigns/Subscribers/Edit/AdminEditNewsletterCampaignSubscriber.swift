import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditNewsletterCampaignSubscriber {
    let controller: any AdminEditNewsletterCampaignSubscriberController
    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminEditNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor:
                    AdminEditNewsletterCampaignSubscriberDefaultInteractor(
                        repository: .init(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                presenter:
                    AdminEditNewsletterCampaignSubscriberDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
            )
        }
    }
}
