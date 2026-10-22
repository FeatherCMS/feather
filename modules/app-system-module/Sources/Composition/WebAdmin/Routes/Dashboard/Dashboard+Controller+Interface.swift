import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Dashboard.Controller {
    protocol Interface: Sendable {

        func getHome(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
