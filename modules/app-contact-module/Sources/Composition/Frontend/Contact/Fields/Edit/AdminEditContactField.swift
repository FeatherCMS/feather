import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

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
