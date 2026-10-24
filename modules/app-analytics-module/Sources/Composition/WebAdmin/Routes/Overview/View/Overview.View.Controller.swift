import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview.View {
    enum Controller {}
}

extension Overview.View.Controller {
    protocol Interface: Sendable {
        func getOverview(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
