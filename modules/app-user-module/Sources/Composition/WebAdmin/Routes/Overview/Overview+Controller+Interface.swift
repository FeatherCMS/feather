import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview.Controller {
    protocol Interface: Sendable {

        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
