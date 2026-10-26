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

extension MagicLink.Add {
    enum Controller {}
}

extension MagicLink.Add.Controller {
    protocol Interface: Sendable {

        func getAddAuthMagicLink(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddAuthMagicLink(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
