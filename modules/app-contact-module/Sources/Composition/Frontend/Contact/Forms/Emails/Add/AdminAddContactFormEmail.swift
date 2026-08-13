import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddContactFormEmail {
    let controller: any AdminAddContactFormEmailController

    init(details: AdminContactFormDetails) {
        controller = AdminAddContactFormEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactFormEmailDefaultInteractor(
                        repository: .init(api: context.contactManagementAPI())
                    ),
                    presenter: AdminAddContactFormEmailDefaultPresenter(
                        request: request,
                        renderEngine: details.renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
