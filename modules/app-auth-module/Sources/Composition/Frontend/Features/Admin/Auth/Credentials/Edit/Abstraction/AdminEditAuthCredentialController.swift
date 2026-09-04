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
import WebComponents
import WebBuilders

protocol AdminEditAuthCredentialController: Sendable {
    func getEditCredential(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    func postEditCredential(request: Request, context: DefaultRequestContext)
        async throws -> Response
}

extension AdminEditAuthCredentialController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/auth/credentials/{id}/edit", use: getEditCredential)
        router.post(
            "/admin/auth/credentials/{id}/edit",
            use: postEditCredential
        )
    }
}
