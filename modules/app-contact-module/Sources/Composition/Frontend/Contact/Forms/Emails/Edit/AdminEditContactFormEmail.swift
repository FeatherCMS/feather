import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditContactFormEmail {
    let controller: any AdminEditContactFormEmailController

    init(details: AdminContactFormDetails) {
        controller = AdminEditContactFormEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormEmailDefaultInteractor(
                        repository: .init(api: context.contactManagementAPI())
                    ),
                    presenter: AdminEditContactFormEmailDefaultPresenter(
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
