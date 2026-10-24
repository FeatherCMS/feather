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

extension Email.Remove {
    enum Controller {}
}

extension Email.Remove.Controller {
    protocol Interface: Sendable {

        func postAuthEmailsRemove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
