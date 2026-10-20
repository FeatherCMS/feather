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

protocol AdminRemoveAuthMagicLinkController: Sendable {

    func postAuthMagicLinksRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveAuthMagicLinkController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post(AuthMagicLinkRoutes.remove, use: postAuthMagicLinksRemove)
    }
}
