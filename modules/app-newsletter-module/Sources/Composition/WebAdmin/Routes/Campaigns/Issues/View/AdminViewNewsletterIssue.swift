import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterIssue {
    let controller: any AdminViewNewsletterIssueController
    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminViewNewsletterIssueDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor: AdminViewNewsletterIssueDefaultInteractor(
                    repository: .init(
                        api: API.Client(
                            environment: environment,
                            requestContext: context
                        )
                    )
                ),
                presenter: AdminViewNewsletterIssueDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
