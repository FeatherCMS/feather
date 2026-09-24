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

protocol AdminListAuthCredentialController: Sendable {
    func getCredentials(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAuthCredentialController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(AuthCredentialRoutes.list, use: getCredentials)
    }
}
