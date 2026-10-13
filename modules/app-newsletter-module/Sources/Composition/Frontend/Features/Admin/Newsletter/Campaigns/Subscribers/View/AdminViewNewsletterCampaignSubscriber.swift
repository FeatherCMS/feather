import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignSubscriber {
    let controller: any AdminViewNewsletterCampaignSubscriberController
    init(
        apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminViewNewsletterCampaignSubscriberDefaultController {
            request,
            context in
            (
                AdminViewNewsletterCampaignSubscriberDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
                ),
                AdminViewNewsletterCampaignSubscriberDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
