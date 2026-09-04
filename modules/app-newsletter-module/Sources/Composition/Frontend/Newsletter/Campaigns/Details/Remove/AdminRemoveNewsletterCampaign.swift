import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveNewsletterCampaign {
    let controller: any AdminRemoveNewsletterCampaignController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterCampaignDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminRemoveNewsletterCampaignDefaultPresenter(
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
