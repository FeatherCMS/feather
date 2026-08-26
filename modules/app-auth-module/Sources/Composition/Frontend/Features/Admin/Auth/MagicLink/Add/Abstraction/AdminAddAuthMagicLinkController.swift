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

protocol AdminAddAuthMagicLinkController: Sendable {

    func getAddAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddAuthMagicLinkController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/auth/magic-links/add/",
            use: getAddAuthMagicLink
        )
        router.post(
            "/admin/auth/magic-links/add/",
            use: postAddAuthMagicLink
        )
    }
}
