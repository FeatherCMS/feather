import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

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
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
