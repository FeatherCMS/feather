import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Overview.Controller {
    protocol Interface: Sendable {
        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
