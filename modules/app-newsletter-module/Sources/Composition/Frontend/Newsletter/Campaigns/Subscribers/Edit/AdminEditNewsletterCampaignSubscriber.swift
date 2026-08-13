import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditNewsletterCampaignSubscriber {
    let controller: any AdminEditNewsletterCampaignSubscriberController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminEditNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(api: context.newsletterManagementAPI())
                ),
                AdminEditNewsletterCampaignSubscriberDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }
    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
