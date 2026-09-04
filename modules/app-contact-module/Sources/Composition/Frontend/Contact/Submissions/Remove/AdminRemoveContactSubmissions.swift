import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveContactSubmissions {
    let controller: any AdminRemoveContactSubmissionsController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactSubmissionsDefaultInteractor(
                        repository:
                            AdminRemoveContactSubmissionsOpenAPIRepository(
                                api: context.contactAdminAPI()
                            )
                    ),
                    presenter: AdminRemoveContactSubmissionsDefaultPresenter(
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
