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

protocol AdminRemoveAuthCredentialController: Sendable {
    func postRemoveCredential(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
}

extension AdminRemoveAuthCredentialController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
    }
}
