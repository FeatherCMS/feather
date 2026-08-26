import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetNewsletterCampaign {
    let controller: any AdminGetNewsletterCampaignController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminGetNewsletterCampaignDefaultInteractor(
                    repository: .init(api: context.newsletterManagementAPI())
                ),
                AdminGetNewsletterCampaignDefaultPresenter(
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
