import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension ContactModule.Form.Edit {
    enum Controller {}
}

extension ContactModule.Form.Edit.Controller {
    protocol Interface: Sendable {
        func edit(request: Request, context: AuthenticatedRequestContext)
            async throws -> HTMLResponse
        func update(request: Request, context: AuthenticatedRequestContext)
            async throws -> Response
        func fields(request: Request, context: AuthenticatedRequestContext)
            async throws -> HTMLResponse
        func updateFields(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
