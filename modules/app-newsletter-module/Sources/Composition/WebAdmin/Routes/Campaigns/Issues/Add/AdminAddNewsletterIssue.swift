import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterIssue {
    let controller: any AdminAddNewsletterIssueController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminAddNewsletterIssueDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminAddNewsletterIssueDefaultInteractor(
                        repository:
                            AdminAddNewsletterIssueOpenAPIRepository(
                                api: API.Client(
                                    environment: environment,
                                    requestContext: context
                                )
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
