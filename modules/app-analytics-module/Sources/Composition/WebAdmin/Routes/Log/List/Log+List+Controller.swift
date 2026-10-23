import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import AnalyticsModule

extension Log.List {
    enum Controller {}
}

extension Log.List.Controller {
    protocol Interface: Sendable {

        func getLogs(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
