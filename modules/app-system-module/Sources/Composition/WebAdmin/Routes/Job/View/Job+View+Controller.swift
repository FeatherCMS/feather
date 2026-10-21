import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Job.View {
    enum Controller {}
}

extension Job.View.Controller {
    protocol Interface: Sendable {
        func getSystemJob(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
