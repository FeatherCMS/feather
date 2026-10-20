import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Dashboard {
    enum Controller {}
}

extension Dashboard.Controller {
    protocol Interface: Sendable {

        func getHome(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
