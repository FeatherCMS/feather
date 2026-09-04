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

struct AdminGetAuthHome {
    let controller: any AdminGetAuthHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAuthHomeDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetAuthHomeDefaultInteractor(),
                    presenter: AdminGetAuthHomeDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
