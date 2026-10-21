import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
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

protocol AdminListAuthCredentialController: Sendable {
    func getCredentials(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAuthCredentialController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: Credential.Router.Routes
    ) {
        router.get(routes.list.routerPath, use: getCredentials)
    }
}
