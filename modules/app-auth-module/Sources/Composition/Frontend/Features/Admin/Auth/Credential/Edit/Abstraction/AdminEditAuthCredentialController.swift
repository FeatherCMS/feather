import AuthAdminAPI
import FeatherWebShared
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
