import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetContactForm {
    let controller: any AdminGetContactFormController

    init(details: AdminContactFormDetails) {
        controller = AdminGetContactFormDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetContactFormDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminGetContactFormDefaultPresenter(
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
