import ContactModule
import FeatherWebShared
import Hummingbird
import WebModuleWebApp

extension Submission {
    enum Controller {}
}

extension Submission.Controller {
    protocol Interface: Sendable {
        func submit(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response
    }
}
