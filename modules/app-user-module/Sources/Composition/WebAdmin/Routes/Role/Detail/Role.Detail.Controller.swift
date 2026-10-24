import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Role.Detail {
    enum Controller {}
}

extension Role.Detail.Controller {
    protocol Interface: Sendable {

        func getUserRole(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
