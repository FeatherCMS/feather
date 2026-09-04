import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditNewsletterIssue {
    let controller: any AdminEditNewsletterIssueController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminEditNewsletterIssueDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminEditNewsletterIssueDefaultPresenter(
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
