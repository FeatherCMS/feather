import FeatherAdmin
import Hummingbird

protocol AdminListMediaVariantProcessorsController: Sendable {
    func getMediaVariantProcessors(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
    func getAddMediaVariantProcessor(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListMediaVariantProcessorsController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            MediaVariantRoutes.processorsRoute,
            use: getMediaVariantProcessors
        )
        router.get(
            MediaVariantRoutes.processorAddRoute,
            use: getAddMediaVariantProcessor
        )
    }
}
