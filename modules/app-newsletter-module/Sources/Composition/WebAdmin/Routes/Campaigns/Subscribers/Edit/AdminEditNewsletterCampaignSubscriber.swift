import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditNewsletterCampaignSubscriber {
    let controller: any AdminEditNewsletterCampaignSubscriberController
    init(
        apiBuilder: NewsletterAdminAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminEditNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminEditNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
                ),
                AdminEditNewsletterCampaignSubscriberDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
