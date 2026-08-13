import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveNewsletterIssue {
    let controller: any AdminRemoveNewsletterIssueController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterIssueDefaultInteractor(
                    repository: .init(api: context.newsletterManagementAPI())
                ),
                AdminRemoveNewsletterIssueDefaultPresenter(
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
