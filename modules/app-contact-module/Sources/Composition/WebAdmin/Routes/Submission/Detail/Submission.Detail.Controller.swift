import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Detail {
    enum Controller {}
}

extension Submission.Detail.Controller {
    protocol Interface: Sendable {
        func get(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
    }
}
