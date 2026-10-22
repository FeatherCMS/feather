import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Remove.Controller {

    protocol Interface: Sendable {

        func postRemoveAccountInvitation(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
