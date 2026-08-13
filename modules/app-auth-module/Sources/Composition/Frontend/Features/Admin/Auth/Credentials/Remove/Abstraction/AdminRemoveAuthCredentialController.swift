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
import WebStandards

protocol AdminRemoveAuthCredentialController: Sendable {
    func getRemoveCredential(request: Request, context: AppRequestContext)
        async throws -> HTMLResponse
    func postRemoveCredential(request: Request, context: AppRequestContext)
        async throws -> Response
}

extension AdminRemoveAuthCredentialController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/auth/credentials/{id}/remove",
            use: getRemoveCredential
        )
        router.post(
            "/admin/auth/credentials/{id}/remove",
            use: postRemoveCredential
        )
    }
}
