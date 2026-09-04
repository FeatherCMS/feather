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

protocol AdminAddAuthCredentialController: Sendable {
    func getAddCredential(request: Request, context: DefaultRequestContext)
        async throws -> HTMLResponse
    func postAddCredential(request: Request, context: DefaultRequestContext)
        async throws -> Response
}

extension AdminAddAuthCredentialController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get("/admin/auth/credentials/add", use: getAddCredential)
        router.post("/admin/auth/credentials/add", use: postAddCredential)
    }
}
