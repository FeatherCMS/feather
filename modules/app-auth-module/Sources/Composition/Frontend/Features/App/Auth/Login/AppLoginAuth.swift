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

struct AppLoginAuth {
    let controller: any AppLoginAuthController

    init(
        repository: any AppLoginAuthRepository,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AppLoginAuthDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AppLoginAuthDefaultInteractor(
                        repository: repository
                    ),
                    presenter: AppLoginAuthDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
