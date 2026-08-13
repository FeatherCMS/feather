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
import WebStandards

struct AdminEditAuthAccessControl {

    let controller: any AdminEditAuthAccessControlController

    init(
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditAuthAccessControlDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthAccessControlDefaultInteractor(
                        repository: AdminEditAuthAccessControlOpenAPIRepository(
                            api: context.authAdminAPI(),
                            userAPI: context.userAdminAPI(),
                            systemAPI: context.systemManagementAPI()
                        )
                    ),
                    presenter: AdminEditAuthAccessControlDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
