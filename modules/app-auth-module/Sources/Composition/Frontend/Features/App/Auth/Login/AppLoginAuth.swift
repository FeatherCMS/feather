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
import WebBuilders
import WebComponents

struct AppLoginAuth {
    let controller: any AppLoginAuthController

    init(
        repository: any AppLoginAuthRepository
    ) {
        self.controller = AppLoginAuthDefaultController(
            buildRuntime: { _, _ in
                (
                    interactor: AppLoginAuthDefaultInteractor(
                        repository: repository
                    ),
                    presenter: AppLoginAuthDefaultPresenter()
                )
            }
        )
    }
}
