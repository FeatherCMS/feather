import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterSubscribers {
    let controller: any AdminRemoveNewsletterSubscribersController

    init(apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterSubscribersDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterSubscribersDefaultInteractor(
                    repository: .init(api: apiBuilder.makeNewsletterAdmin(context))
                ),
                AdminRemoveNewsletterSubscribersDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
