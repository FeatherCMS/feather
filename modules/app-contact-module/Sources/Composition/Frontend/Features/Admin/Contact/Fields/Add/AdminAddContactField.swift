import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactField {
    let controller: any AdminAddContactFieldController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddContactFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactFieldDefaultInteractor(
                        repository: AdminAddContactFieldOpenAPIRepository(
                            api: context.contactAdminAPI()
                        )
                    ),
                    presenter: AdminAddContactFieldDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
