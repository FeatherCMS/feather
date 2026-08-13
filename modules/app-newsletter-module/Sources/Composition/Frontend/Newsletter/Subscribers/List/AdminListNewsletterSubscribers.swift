import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListNewsletterSubscribers {
    let controller: any AdminListNewsletterSubscribersController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListNewsletterSubscribersDefaultController {
            request,
            context in
            (
                AdminListNewsletterSubscribersDefaultInteractor(
                    repository: .init(api: context.newsletterManagementAPI())
                ),
                AdminListNewsletterSubscribersDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
