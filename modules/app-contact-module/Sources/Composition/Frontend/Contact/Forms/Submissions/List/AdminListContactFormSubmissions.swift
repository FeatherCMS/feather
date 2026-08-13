import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListContactFormSubmissions {
    let controller: any AdminListContactFormSubmissionsController

    init(submissions: AdminContactFormSubmissions) {
        controller = AdminListContactFormSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor:
                        AdminListContactFormSubmissionsDefaultInteractor(
                            repository: .init(
                                api: context.contactManagementAPI()
                            )
                        ),
                    presenter: AdminListContactFormSubmissionsDefaultPresenter(
                        request: request,
                        renderEngine: submissions.renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
