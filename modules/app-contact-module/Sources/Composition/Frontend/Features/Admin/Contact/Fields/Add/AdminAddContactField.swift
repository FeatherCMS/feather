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
    init(apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminAddContactFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactFieldDefaultInteractor(
                        repository: AdminAddContactFieldOpenAPIRepository(
                            api: apiBuilder.makeContactAdmin(context)
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
