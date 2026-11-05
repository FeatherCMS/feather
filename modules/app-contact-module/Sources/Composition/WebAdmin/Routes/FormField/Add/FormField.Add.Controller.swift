import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension FormField.Add {
    enum Controller {}
}

extension FormField.Add.Controller {
    protocol Interface: Sendable {
        func getAddContactField(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddContactField(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
