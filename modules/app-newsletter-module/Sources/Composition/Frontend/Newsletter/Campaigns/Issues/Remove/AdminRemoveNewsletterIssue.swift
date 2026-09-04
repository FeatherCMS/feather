import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveNewsletterIssue {
    let controller: any AdminRemoveNewsletterIssueController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterIssueDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminRemoveNewsletterIssueDefaultPresenter(
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
