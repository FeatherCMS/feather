import FeatherWebShared
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormSubmission {
    let controller: any AdminEditContactFormSubmissionController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Contact.Router.Routes
    ) {
        controller = AdminEditContactFormSubmissionDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminEditContactFormSubmissionDefaultInteractor(
                        repository: .init(
                            api: API.Client(
                                apiBaseURL: environment.apiBaseURL,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminEditContactFormSubmissionDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine,
                        routes: routes
                    )
                )
            }
        )
    }
}
