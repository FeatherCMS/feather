import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactField {
    let controller: any AdminEditContactFieldController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditContactFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFieldDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminEditContactFieldDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
