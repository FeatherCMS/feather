import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterIssue {
    let controller: any AdminRemoveNewsletterIssueController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminRemoveNewsletterIssueDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor: AdminRemoveNewsletterIssueDefaultInteractor(
                    repository: .init(
                        api: API.Client(
                            environment: environment,
                            requestContext: context
                        )
                    )
                ),
                presenter: AdminRemoveNewsletterIssueDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }

    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            NewsletterAdminRoutes.issueRemoveRoute,
            use: controller.confirm
        )
        router.post(
            NewsletterAdminRoutes.issueRemoveRoute,
            use: controller.remove
        )
    }
}
