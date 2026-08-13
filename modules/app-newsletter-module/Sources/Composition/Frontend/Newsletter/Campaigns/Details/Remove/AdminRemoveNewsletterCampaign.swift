import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveNewsletterCampaign {
    let controller: any AdminRemoveNewsletterCampaignController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterCampaignDefaultInteractor(
                    repository: .init(api: context.newsletterManagementAPI())
                ),
                AdminRemoveNewsletterCampaignDefaultPresenter(
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
