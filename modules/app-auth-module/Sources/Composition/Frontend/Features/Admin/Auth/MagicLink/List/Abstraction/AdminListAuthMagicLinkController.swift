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

protocol AdminListAuthMagicLinkController: Sendable {

    func getAuthMagicLinks(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAuthMagicLinksRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminListAuthMagicLinkController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            AuthMagicLinkRoutes.list,
            use: getAuthMagicLinks
        )
        router.post(
            AuthMagicLinkRoutes.remove,
            use: postAuthMagicLinksRemove
        )
    }
}
