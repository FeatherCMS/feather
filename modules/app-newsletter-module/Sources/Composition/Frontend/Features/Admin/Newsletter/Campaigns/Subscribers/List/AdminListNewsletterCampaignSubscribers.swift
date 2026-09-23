import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterCampaignSubscribers {
    let controller: any AdminListNewsletterCampaignSubscribersController
    init(apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminListNewsletterCampaignSubscribersDefaultController {
            request,
            context in
            (
                AdminListNewsletterCampaignSubscribersDefaultInteractor(
                    repository: .init(api: apiBuilder.makeNewsletterAdmin(context))
                ),
                AdminListNewsletterCampaignSubscribersDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
