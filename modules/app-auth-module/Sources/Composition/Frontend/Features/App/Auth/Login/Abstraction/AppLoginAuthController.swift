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

protocol AppLoginAuthController: Sendable {

    func getLogin(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postLogin(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AppLoginAuthController {

    func route(
        on router: Router<DefaultRequestContext>
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
