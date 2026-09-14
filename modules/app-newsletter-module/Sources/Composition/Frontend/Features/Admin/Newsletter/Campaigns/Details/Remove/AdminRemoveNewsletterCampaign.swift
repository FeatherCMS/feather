import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

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
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
