import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddContactFormField {
    let controller: any AdminAddContactFormFieldController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddContactFormFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactFormFieldDefaultInteractor(
                        repository: AdminAddContactFormFieldOpenAPIRepository(
                            api: context.contactAdminAPI()
                        )
                    ),
                    presenter: AdminAddContactFormFieldDefaultPresenter(
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
