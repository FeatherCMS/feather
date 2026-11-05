import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Submission.Remove {
    enum Controller {}
}
extension Submission.Remove.Controller {
    protocol Interface: Sendable {
        func remove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response

        func removeForForm(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
