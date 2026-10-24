import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.List {
    enum Controller {}
}

extension Variant.List.Controller {
    protocol Interface: Sendable {
        func getMediaVariants(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
