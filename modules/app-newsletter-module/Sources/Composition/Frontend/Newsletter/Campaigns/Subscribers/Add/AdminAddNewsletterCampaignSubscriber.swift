import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterCampaignSubscriber {
    let controller: any AdminAddNewsletterCampaignSubscriberController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminAddNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminAddNewsletterCampaignSubscriberDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }
    func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
