import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Variable.List {
    enum Controller {}
}

extension Variable.List.Controller {
    protocol Interface: Sendable {

        func getSystemVariables(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
