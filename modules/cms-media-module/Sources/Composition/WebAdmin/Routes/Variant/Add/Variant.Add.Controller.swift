import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Add {
    enum Controller {}
}

extension Variant.Add.Controller {
    protocol Interface: Sendable {
        func getAddMediaVariant(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> HTMLResponse
        func postAddMediaVariant(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> Response
    }
}
