import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditContactFormSubmission {
    let controller: any AdminEditContactFormSubmissionController

    init(submissions: AdminContactFormSubmissions) {
        controller = AdminEditContactFormSubmissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormSubmissionDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminEditContactFormSubmissionDefaultPresenter(
                        request: request,
                        renderEngine: submissions.renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
