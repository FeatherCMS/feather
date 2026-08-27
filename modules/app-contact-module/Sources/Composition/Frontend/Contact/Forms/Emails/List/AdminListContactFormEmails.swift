import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListContactFormEmails {
    let controller: any AdminListContactFormEmailsController

    init(details: AdminContactFormDetails) {
        controller = AdminListContactFormEmailsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFormEmailsDefaultInteractor(
                        repository: .init(api: context.contactManagementAPI())
                    ),
                    presenter: AdminListContactFormEmailsDefaultPresenter(
                        request: request,
                        renderEngine: details.renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
