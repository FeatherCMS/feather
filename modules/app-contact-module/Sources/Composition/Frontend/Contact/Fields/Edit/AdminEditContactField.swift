import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditContactField {
    let controller: any AdminEditContactFieldController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditContactFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFieldDefaultInteractor(
                        repository: .init(api: context.contactManagementAPI())
                    ),
                    presenter: AdminEditContactFieldDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
