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

protocol AdminEditAuthCredentialController: Sendable {
    func getEditCredential(request: Request, context: AuthenticatedRequestContext)
        async throws -> HTMLResponse
    func postEditCredential(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
}

extension AdminEditAuthCredentialController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            AuthCredentialRoutes.edit(RouterPath("{id}")),
            use: getEditCredential
        )
        router.post(
            AuthCredentialRoutes.edit(RouterPath("{id}")),
            use: postEditCredential
        )
    }
}
