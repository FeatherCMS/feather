import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Processor.List.Controller {
    protocol Interface: Sendable {
        func getMediaVariantProcessors(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
        func getAddMediaVariantProcessor(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
