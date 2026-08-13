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

struct AppLogoutAuth {
    let controller: any AppLogoutAuthController

    init(repository: any AppLogoutAuthRepository) {
        self.controller = AppLogoutAuthDefaultController(
            buildRuntime: { _, _ in
                (
                    interactor: AppLogoutAuthDefaultInteractor(
                        repository: repository
                    ),
                    presenter: AppLogoutAuthDefaultPresenter()
                )
            }
        )
    }
}
