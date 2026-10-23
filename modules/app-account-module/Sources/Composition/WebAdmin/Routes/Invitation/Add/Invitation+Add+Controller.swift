import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Add {
    enum Controller {}
}

extension Invitation.Add.Controller {

    protocol Interface: Sendable {

        func getAddAccountInvitation(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddAccountInvitation(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
