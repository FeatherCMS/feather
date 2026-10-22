import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Identity.Remove.Controller {
    protocol Interface: Sendable {

        func postRemoveUserIdentity(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response

        func postRemoveUserIdentities(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
