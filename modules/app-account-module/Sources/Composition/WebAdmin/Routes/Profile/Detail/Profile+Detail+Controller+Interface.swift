import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Profile.Detail.Controller {

    protocol Interface: Sendable {

        func getProfile(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
