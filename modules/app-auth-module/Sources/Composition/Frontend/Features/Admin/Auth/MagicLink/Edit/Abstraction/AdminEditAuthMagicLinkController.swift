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
import WebBuilders
import WebComponents

protocol AdminEditAuthMagicLinkController: Sendable {

    func getEditAuthMagicLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditAuthMagicLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditAuthMagicLinkController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AuthMagicLinkRoutes.edit(RouterPath("{id}")),
            use: getEditAuthMagicLink
        )
        router.post(
            AuthMagicLinkRoutes.edit(RouterPath("{id}")),
            use: postEditAuthMagicLink
        )
    }
}
