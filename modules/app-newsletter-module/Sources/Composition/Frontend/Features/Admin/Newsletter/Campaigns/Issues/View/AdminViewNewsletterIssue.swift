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
    init(
        apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminViewNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminViewNewsletterIssueDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
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
