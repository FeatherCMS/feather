import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterSubscriber {
    let controller: any AdminAddNewsletterSubscriberController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterSubscriberDefaultController {
            request,
            context in
            (
                AdminAddNewsletterSubscriberDefaultInteractor(
                    repository: .init(api: context.newsletterManagementAPI())
                ),
                AdminAddNewsletterSubscriberDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }
}
