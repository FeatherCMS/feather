import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Identity.Detail.Controller {
    protocol Interface: Sendable {

        func getUserIdentity(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
