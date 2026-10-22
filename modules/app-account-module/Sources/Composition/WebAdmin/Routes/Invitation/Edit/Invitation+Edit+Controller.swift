import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Edit.Controller {

    protocol Interface: Sendable {

        func getEditAccountInvitation(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditAccountInvitation(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
