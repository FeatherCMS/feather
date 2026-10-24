import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird

extension ContactModule.Form {
    enum View {}
}

extension ContactModule.Form.View {
    enum Controller {}
}

extension ContactModule.Form.View.Controller {
    protocol Interface: Sendable {
        func get(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
    }
}
