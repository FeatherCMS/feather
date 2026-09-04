import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditNewsletterCampaign {
    let controller: any AdminEditNewsletterCampaignController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminEditNewsletterCampaignDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminEditNewsletterCampaignDefaultPresenter(
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
