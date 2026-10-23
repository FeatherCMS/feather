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
    }
}

extension Submission.Remove.Controller.Interface {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(ContactAdminRoutes.submissionRemove, use: remove)
    }
}
