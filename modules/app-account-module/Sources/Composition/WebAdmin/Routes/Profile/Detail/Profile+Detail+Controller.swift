import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Profile.Detail.Controller {

    protocol Interface: Sendable {

        func getAccountProfile(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
