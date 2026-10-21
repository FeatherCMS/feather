import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Job.List {
    enum Controller {}
}

extension Job.List.Controller {
    protocol Interface: Sendable {
        func getSystemJobs(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
