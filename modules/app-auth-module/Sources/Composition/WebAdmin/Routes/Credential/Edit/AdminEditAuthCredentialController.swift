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

protocol AdminEditAuthCredentialController: Sendable {
    func getEditCredential(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    func postEditCredential(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
}

extension AdminEditAuthCredentialController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: Credential.Router.Routes
    ) {
        router.get(routes.edit.routerPath, use: getEditCredential)
        router.post(routes.edit.routerPath, use: postEditCredential)
    }
}
