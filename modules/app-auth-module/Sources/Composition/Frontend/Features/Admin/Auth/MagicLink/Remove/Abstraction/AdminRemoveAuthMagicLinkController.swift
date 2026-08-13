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

protocol AdminRemoveAuthMagicLinkController: Sendable {

    func getRemoveAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveAuthMagicLink(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveAuthMagicLinkController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/auth/magic-links/{id}/remove/",
            use: getRemoveAuthMagicLink
        )
        router.post(
            "/admin/auth/magic-links/{id}/remove/",
            use: postRemoveAuthMagicLink
        )
    }
}
