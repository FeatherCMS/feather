import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterIssue {
    let controller: any AdminViewNewsletterIssueController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminViewNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminViewNewsletterIssueDefaultInteractor(
                    repository: .init(api: context.newsletterAdminAPI())
                ),
                AdminViewNewsletterIssueDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
