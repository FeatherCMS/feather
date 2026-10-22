import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterCampaignSubscriber {
    let controller: any AdminRemoveNewsletterCampaignSubscriberController
    init(
        apiBuilder: NewsletterAdminAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminRemoveNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
                ),
                AdminRemoveNewsletterCampaignSubscriberDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
