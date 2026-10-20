import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Job.List {
    enum Controller {}
}

extension WebAdmin.System.Job.List.Controller {
    protocol Interface: Sendable {
        func getSystemJobs(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
