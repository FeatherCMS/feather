import FeatherWebAdmin
import Hummingbird
import UserModule

extension Identity.Detail {
    enum Controller {}
}

extension Identity.Detail.Controller {
    protocol Interface: Sendable {

        func getUserIdentity(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

    }
}
