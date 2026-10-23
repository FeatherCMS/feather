import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterIssues {
    let controller: any AdminListNewsletterIssuesController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminListNewsletterIssuesDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor: AdminListNewsletterIssuesDefaultInteractor(
                    repository: .init(
                        api: API.Client(
                            environment: environment,
                            requestContext: context
                        )
                    )
                ),
                presenter: AdminListNewsletterIssuesDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
