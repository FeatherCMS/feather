import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditNewsletterIssue {
    let controller: any AdminEditNewsletterIssueController

    init(
        apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminEditNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminEditNewsletterIssueDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
                ),
                AdminEditNewsletterIssueDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
