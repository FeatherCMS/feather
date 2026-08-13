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

struct AdminEditAuthProfile {
    let controller: any AdminEditAuthProfileController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAuthProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthProfileDefaultInteractor(
                        repository: AdminEditAuthProfileOpenAPIRepository(
                            api: context.userAdminAPI()
                        )
                    ),
                    presenter: AdminEditAuthProfileDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
