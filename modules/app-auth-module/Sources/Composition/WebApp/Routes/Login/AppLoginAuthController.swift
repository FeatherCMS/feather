import AuthAppAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebApp
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
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
