import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension ContactModule.Form.Remove {
    enum Controller {}
}

extension ContactModule.Form.Remove.Controller {
    protocol Interface: Sendable {
        func remove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
