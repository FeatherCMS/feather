import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminGetNewsletterCampaign {
    let controller: any AdminGetNewsletterCampaignController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminGetNewsletterCampaignDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminGetNewsletterCampaignDefaultPresenter(
                    request: request,
                        context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
