import FeatherWebAdmin
import Hummingbird

extension Overview {
    enum Controller {}
}

extension Overview.Controller {
    protocol Interface: Sendable {
        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
