import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterSubscribers {
    let controller: any AdminListNewsletterSubscribersController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListNewsletterSubscribersDefaultController {
            request,
            context in
            (
                AdminListNewsletterSubscribersDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminListNewsletterSubscribersDefaultPresenter(
                    request: request,
                        context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
