import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

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
                        context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
