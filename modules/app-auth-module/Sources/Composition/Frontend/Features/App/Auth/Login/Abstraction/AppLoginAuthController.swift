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

protocol AppLoginAuthController: Sendable {

    func getLogin(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postLogin(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AppLoginAuthController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/login/",
            use: getLogin
        )
        router.post(
            "/login/",
            use: postLogin
        )
    }
}
