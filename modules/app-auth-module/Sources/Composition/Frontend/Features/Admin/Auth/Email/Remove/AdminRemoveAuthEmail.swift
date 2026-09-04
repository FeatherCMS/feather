import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

struct AdminRemoveAuthEmail {
    let controller: any AdminRemoveAuthEmailController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveAuthEmailDefaultInteractor(
                        repository: AdminRemoveAuthEmailOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminRemoveAuthEmailDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
