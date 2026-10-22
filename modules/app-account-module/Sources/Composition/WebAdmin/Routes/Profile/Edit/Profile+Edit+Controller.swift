import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Profile.Edit.Controller {

    protocol Interface: Sendable {

        func getEditAccountProfile(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditAccountProfile(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
