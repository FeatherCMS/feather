import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetNewsletterIssue {
    let controller: any AdminGetNewsletterIssueController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminGetNewsletterIssueDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminGetNewsletterIssueDefaultPresenter(
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
