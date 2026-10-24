import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Edit {
    enum Controller {}
}

extension Submission.Edit.Controller {
    protocol Interface: Sendable {
        func update(request: Request, context: AuthenticatedRequestContext)
            async throws -> Response
    }
}
