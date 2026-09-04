import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListContactFields {
    let controller: any AdminListContactFieldsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListContactFieldsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFieldsDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminListContactFieldsDefaultPresenter(
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
