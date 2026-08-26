import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditContactFormField {
    let controller: any AdminEditContactFormFieldController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditContactFormFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormFieldDefaultInteractor(
                        repository: .init(api: context.contactManagementAPI())
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
