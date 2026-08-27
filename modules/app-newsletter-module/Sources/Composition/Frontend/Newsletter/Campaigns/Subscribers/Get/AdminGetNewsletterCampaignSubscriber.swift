import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetNewsletterCampaignSubscriber {
    let controller: any AdminGetNewsletterCampaignSubscriberController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminGetNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(api: context.newsletterManagementAPI())
                ),
                AdminGetNewsletterCampaignSubscriberDefaultPresenter(
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
