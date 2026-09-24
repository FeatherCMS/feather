import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterIssue {
    let controller: any AdminRemoveNewsletterIssueController

    init(
        apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminRemoveNewsletterIssueDefaultController {
            request,
            context in
            (
                AdminRemoveNewsletterIssueDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
                ),
                AdminRemoveNewsletterIssueDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
