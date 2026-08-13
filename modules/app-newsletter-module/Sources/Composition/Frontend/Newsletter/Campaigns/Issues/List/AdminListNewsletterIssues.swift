import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListNewsletterIssues {
    let controller: any AdminListNewsletterIssuesController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListNewsletterIssuesDefaultController {
            request,
            context in
            (
                AdminListNewsletterIssuesDefaultInteractor(
                    repository: .init(api: context.newsletterManagementAPI())
                ),
                AdminListNewsletterIssuesDefaultPresenter(
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
