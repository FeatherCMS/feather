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

struct AdminEditAuthEmail {
    let controller: any AdminEditAuthEmailController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthEmailDefaultInteractor(
                        repository: AdminEditAuthEmailOpenAPIRepository(
                            api: context.authAdminAPI(),
                            userAPI: context.userAdminAPI()
                        )
                    ),
                    presenter: AdminEditAuthEmailDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
