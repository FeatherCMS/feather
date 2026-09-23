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
    init(apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminViewNewsletterCampaignDefaultController {
            request,
            context in
            (
                AdminViewNewsletterCampaignDefaultInteractor(
                    repository: .init(api: apiBuilder.makeNewsletterAdmin(context))
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
