import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditNewsletterCampaignSubscriber {
    let controller: any AdminEditNewsletterCampaignSubscriberController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminEditNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
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
