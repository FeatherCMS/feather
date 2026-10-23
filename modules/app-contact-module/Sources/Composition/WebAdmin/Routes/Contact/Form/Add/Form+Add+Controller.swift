import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Form.Add {
    enum Controller {}
}

extension Form.Add.Controller {
    protocol Interface: Sendable {
        func add(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func create(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
