import FeatherWebAdmin
import Hummingbird
import UserModule

extension Identity.Edit {
    enum Controller {}
}

extension Identity.Edit.Controller {
    protocol Interface: Sendable {

        func getEditUserIdentity(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditUserIdentity(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
