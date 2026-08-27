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

protocol AdminListAuthCredentialController: Sendable {
    func getCredentials(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListAuthCredentialController {
    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/auth/credentials/{id}",
            use: getCredentials
        )
    }
}
