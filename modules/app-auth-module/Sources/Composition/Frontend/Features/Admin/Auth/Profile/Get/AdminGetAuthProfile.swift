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

struct AdminGetAuthProfile {
    let controller: any AdminGetAuthProfileController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAuthProfileDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetAuthProfileDefaultInteractor(),
                    presenter: AdminGetAuthProfileDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
