import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.List {
    enum Controller {}
}

extension Invitation.List.Controller {

    protocol Interface: Sendable {

        func getAccountInvitations(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
