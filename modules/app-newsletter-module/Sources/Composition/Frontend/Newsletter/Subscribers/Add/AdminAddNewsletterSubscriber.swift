import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterSubscriber {
    let controller: any AdminAddNewsletterSubscriberController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterSubscriberDefaultController {
            request,
            context in
            (
                AdminAddNewsletterSubscriberDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminAddNewsletterSubscriberDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }
}
