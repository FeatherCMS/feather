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

protocol AdminListAuthCredentialIdentityController: Sendable {
    func getIdentities(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAuthCredentialIdentityController {
    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get("/admin/auth/credentials", use: getIdentities)
    }
}
