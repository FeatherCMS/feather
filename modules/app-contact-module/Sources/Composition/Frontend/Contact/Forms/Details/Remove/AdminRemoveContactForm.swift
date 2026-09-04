import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveContactForm {
    let controller: any AdminRemoveContactFormController

    init(details: AdminContactFormDetails) {
        controller = AdminRemoveContactFormDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactFormDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminRemoveContactFormDefaultPresenter(
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
