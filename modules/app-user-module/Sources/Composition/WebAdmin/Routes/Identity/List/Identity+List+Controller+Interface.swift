import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Identity.List.Controller {
    protocol Interface: Sendable {

        func getUserIdentities(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
