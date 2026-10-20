import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Job.View {
    enum Controller {}
}

extension WebAdmin.System.Job.View.Controller {
    protocol Interface: Sendable {
        func getSystemJob(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
