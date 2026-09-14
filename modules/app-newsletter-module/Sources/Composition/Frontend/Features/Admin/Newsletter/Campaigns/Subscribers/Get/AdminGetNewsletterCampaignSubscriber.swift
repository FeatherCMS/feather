import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminGetNewsletterCampaignSubscriber {
    let controller: any AdminGetNewsletterCampaignSubscriberController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminGetNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminGetNewsletterCampaignSubscriberDefaultPresenter(
                    request: request,
                        context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
