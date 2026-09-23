import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterIssue {
    let controller: any AdminAddNewsletterIssueController

    init(apiBuilder: NewsletterAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterIssueDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddNewsletterIssueDefaultInteractor(
                        repository:
                            AdminAddNewsletterIssueOpenAPIRepository(
                                api: apiBuilder.makeNewsletterAdmin(context)
                            )
                    ),
                    presenter: AdminAddNewsletterIssueDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
