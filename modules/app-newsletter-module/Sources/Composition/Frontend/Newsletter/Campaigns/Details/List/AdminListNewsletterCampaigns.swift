import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListNewsletterCampaigns {
    let controller: any AdminListNewsletterCampaignsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListNewsletterCampaignsDefaultController {
            request,
            context in
            (
                AdminListNewsletterCampaignsDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminListNewsletterCampaignsDefaultPresenter(
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
