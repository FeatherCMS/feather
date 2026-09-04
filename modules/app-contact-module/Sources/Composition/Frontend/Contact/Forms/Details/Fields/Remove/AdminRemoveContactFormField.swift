import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveContactFormField {
    let controller: any AdminRemoveContactFormFieldController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactFormFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactFormFieldDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminRemoveContactFormFieldDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
