import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterCampaignSubscribers {
    let controller: any AdminListNewsletterCampaignSubscribersController
    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminListNewsletterCampaignSubscribersDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor:
                    AdminListNewsletterCampaignSubscribersDefaultInteractor(
                        repository: .init(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            )
                        )
                    ),
                presenter:
                    AdminListNewsletterCampaignSubscribersDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
            )
        }
    }
}
