import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Variable.View {
    enum Controller {}
}

extension Variable.View.Controller {
    protocol Interface: Sendable {

        func getSystemVariable(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
