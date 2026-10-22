import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Tag {
    enum Remove {}
}

extension Tag.Remove {
    enum Controller {}
}

extension Tag.Remove.Controller {
    protocol Interface: Sendable {
        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
