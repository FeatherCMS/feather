import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaign {
    let controller: any AdminViewNewsletterCampaignController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminViewNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminViewNewsletterCampaignDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminViewNewsletterCampaignDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
