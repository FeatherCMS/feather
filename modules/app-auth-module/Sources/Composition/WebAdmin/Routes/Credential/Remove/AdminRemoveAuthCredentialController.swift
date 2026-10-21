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

protocol AdminRemoveAuthCredentialController: Sendable {
    func postRemoveCredential(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
}

extension AdminRemoveAuthCredentialController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        routes: Credential.Router.Routes
    ) {
        router.post(routes.remove.routerPath, use: postRemoveCredential)
    }
}
