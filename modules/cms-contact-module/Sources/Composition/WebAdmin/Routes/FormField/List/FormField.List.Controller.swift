import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension FormField.List {
    enum Controller {}
}

extension FormField.List.Controller {
    protocol Interface: Sendable {
        func list(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
    }
}
