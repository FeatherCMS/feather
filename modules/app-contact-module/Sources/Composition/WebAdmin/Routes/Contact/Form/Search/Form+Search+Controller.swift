import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Form.Search {
    enum Controller {}
}

extension Form.Search.Controller {
    protocol Interface: Sendable {
        func search(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
