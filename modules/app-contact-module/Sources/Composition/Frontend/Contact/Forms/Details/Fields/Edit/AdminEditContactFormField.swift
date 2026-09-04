import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditContactFormField {
    let controller: any AdminEditContactFormFieldController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditContactFormFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormFieldDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminEditContactFormFieldDefaultPresenter(
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
