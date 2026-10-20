import FeatherWebAdmin
import Hummingbird
import UserModule

extension Identity.List {
    enum Controller {}
}

extension Identity.List.Controller {
    protocol Interface: Sendable {

        func getUserIdentities(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
