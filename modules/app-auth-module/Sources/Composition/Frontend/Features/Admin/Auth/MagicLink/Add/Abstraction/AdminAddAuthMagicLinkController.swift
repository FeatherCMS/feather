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

protocol AdminAddAuthMagicLinkController: Sendable {

    func getAddAuthMagicLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddAuthMagicLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddAuthMagicLinkController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AuthMagicLinkRoutes.add,
            use: getAddAuthMagicLink
        )
        router.post(
            AuthMagicLinkRoutes.add,
            use: postAddAuthMagicLink
        )
    }
}
