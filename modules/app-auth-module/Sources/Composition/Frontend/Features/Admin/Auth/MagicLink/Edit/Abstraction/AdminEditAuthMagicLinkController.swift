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

protocol AdminEditAuthMagicLinkController: Sendable {

    func getEditAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditAuthMagicLinkController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/auth/magic-links/{id}/edit/",
            use: getEditAuthMagicLink
        )
        router.post(
            "/admin/auth/magic-links/{id}/edit/",
            use: postEditAuthMagicLink
        )
    }
}
