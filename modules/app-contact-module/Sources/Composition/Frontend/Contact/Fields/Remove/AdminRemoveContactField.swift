import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactField {
    let controller: any AdminRemoveContactFieldController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactFieldDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminRemoveContactFieldDefaultPresenter(
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
