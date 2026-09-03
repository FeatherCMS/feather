import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetContactFormSubmission {
    let controller: any AdminGetContactFormSubmissionController

    init(submissions: AdminContactFormSubmissions) {
        controller = AdminGetContactFormSubmissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetContactFormSubmissionDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminGetContactFormSubmissionDefaultPresenter(
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
