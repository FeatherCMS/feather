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

protocol AdminAddAuthCredentialController: Sendable {
    func getAddCredential(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    func postAddCredential(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
}

extension AdminAddAuthCredentialController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: Credential.Router.Routes
    ) {
        router.get(routes.add.routerPath, use: getAddCredential)
        router.post(routes.add.routerPath, use: postAddCredential)
    }
}
