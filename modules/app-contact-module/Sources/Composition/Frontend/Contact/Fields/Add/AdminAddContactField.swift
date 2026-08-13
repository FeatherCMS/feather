import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddContactField {
    let controller: any AdminAddContactFieldController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddContactFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactFieldDefaultInteractor(
                        repository: AdminAddContactFieldOpenAPIRepository(
                            api: context.contactManagementAPI()
                        )
                    ),
                    presenter: AdminAddContactFieldDefaultPresenter(
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
