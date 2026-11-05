import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Session.Remove {
    enum Controller {}
}

extension Session.Remove.Controller {
    protocol Interface: Sendable {

        func postRemoveAuthSession(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
