import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFormEmail {
    let controller: any AdminRemoveContactFormEmailController

    init(details: AdminContactFormDetails) {
        controller = AdminRemoveContactFormEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactFormEmailDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminRemoveContactFormEmailDefaultPresenter(
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
