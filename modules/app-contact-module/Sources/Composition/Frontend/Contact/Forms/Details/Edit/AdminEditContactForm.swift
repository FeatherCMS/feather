import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditContactForm {
    let controller: any AdminEditContactFormController

    init(details: AdminContactFormDetails) {
        controller = AdminEditContactFormDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminEditContactFormDefaultPresenter(
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
