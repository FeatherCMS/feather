import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFormSubmissions {
    let controller: any AdminRemoveContactFormSubmissionsController

    init(submissions: AdminContactFormSubmissions) {
        controller = AdminRemoveContactFormSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor:
                        AdminRemoveContactFormSubmissionsDefaultInteractor(
                            repository: .init(
                                api: context.contactManagementAPI()
                            )
                        ),
                    presenter:
                        AdminRemoveContactFormSubmissionsDefaultPresenter(
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
