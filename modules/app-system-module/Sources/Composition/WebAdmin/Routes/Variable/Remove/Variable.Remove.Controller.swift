import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SystemModule

extension Variable.Remove {
    enum Controller {}
}

extension Variable.Remove.Controller {
    protocol Interface: Sendable {

        func postRemoveSystemVariables(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
