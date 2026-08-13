import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveNewsletterCampaignSubscriber {
    let controller: any AdminRemoveNewsletterCampaignSubscriberController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(api: context.newsletterManagementAPI())
                ),
                AdminRemoveNewsletterCampaignSubscriberDefaultPresenter(
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
