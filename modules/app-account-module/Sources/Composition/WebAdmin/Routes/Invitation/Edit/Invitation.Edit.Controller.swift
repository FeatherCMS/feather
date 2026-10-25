import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Edit {
    enum Controller {}
}

extension Invitation.Edit.Controller {

    protocol Interface: Sendable {

        func getEdit(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditPath(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
