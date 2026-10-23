import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterCampaignSubscriber {
    let controller: any AdminRemoveNewsletterCampaignSubscriberController
    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminRemoveNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor:
                    AdminRemoveNewsletterCampaignSubscriberDefaultInteractor(
                        repository: .init(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                presenter:
                    AdminRemoveNewsletterCampaignSubscriberDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
            )
        }
    }
}
