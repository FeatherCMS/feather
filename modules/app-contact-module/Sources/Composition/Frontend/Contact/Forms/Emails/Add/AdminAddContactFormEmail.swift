import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddContactFormEmail {
    let controller: any AdminAddContactFormEmailController

    init(details: AdminContactFormDetails) {
        controller = AdminAddContactFormEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactFormEmailDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminAddContactFormEmailDefaultPresenter(
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
