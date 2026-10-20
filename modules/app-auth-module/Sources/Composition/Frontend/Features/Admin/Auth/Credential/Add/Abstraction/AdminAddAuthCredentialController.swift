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
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(AuthCredentialRoutes.add, use: getAddCredential)
        router.post(AuthCredentialRoutes.add, use: postAddCredential)
    }
}
