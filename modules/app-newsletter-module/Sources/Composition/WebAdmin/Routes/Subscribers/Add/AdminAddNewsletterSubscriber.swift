import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterSubscriber {
    let controller: any AdminAddNewsletterSubscriberController

    init(
        apiBuilder: NewsletterAdminAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminAddNewsletterSubscriberDefaultController {
            request,
            context in
            (
                AdminAddNewsletterSubscriberDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
                ),
                AdminAddNewsletterSubscriberDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
