import ContactWebShared
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormSubmission {
    let controller: any AdminEditContactFormSubmissionController

    init(
        apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine,
        routes: Contact.Router.Routes
    ) {
        controller = AdminEditContactFormSubmissionDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminEditContactFormSubmissionDefaultInteractor(
                        repository: .init(
                            api: apiBuilder.makeContactAdmin(context)
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
