import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Add {
    enum Controller {}
}

extension Invitation.Add.Controller {

    protocol Interface: Sendable {

        func getAdd(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddPath(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
