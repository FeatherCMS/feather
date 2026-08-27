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

protocol AdminGetAuthMagicLinkController: Sendable {

    func getAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAuthMagicLinkController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/auth/magic-links/{id}/",
            use: getAuthMagicLink
        )
    }
}
