import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Remove {
    enum Controller {}
}

extension Variant.Remove.Controller {
    protocol Interface: Sendable {
        func postRemoveMediaVariants(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
