import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

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
        on router: Hummingbird.Router<DefaultRequestContext>
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
