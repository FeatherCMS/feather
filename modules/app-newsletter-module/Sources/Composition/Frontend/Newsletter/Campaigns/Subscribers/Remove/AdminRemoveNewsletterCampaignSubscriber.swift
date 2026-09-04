import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveNewsletterCampaignSubscriber {
    let controller: any AdminRemoveNewsletterCampaignSubscriberController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminRemoveNewsletterCampaignSubscriberDefaultPresenter(
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
