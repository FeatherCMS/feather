import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

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
                    renderEngine: renderingEngine
                )
            )
        }
    }

    func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
