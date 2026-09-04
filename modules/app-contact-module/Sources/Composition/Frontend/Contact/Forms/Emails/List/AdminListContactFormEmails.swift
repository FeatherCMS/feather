import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListContactFormEmails {
    let controller: any AdminListContactFormEmailsController

    init(details: AdminContactFormDetails) {
        controller = AdminListContactFormEmailsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFormEmailsDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
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
