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
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getAuthMagicLinksRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postAuthMagicLinksRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListAuthMagicLinkController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            AuthMagicLinkRoutes.list,
            use: getAuthMagicLinks
        )
        router.get(
            AuthMagicLinkRoutes.remove,
            use: getAuthMagicLinksRemoveConfirmation
        )
        router.post(
            AuthMagicLinkRoutes.remove,
            use: postAuthMagicLinksRemove
        )
    }
}
