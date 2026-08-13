import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetNewsletterIssue {
    let controller: any AdminGetNewsletterIssueController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminGetNewsletterIssueDefaultInteractor(
                    repository: .init(api: context.newsletterManagementAPI())
                ),
                AdminGetNewsletterIssueDefaultPresenter(
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
