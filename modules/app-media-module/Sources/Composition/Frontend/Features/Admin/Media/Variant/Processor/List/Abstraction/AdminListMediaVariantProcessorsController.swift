import FeatherAdmin
import Hummingbird

protocol AdminListMediaVariantProcessorsController: Sendable {
    func getMediaVariantProcessors(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
    func getAddMediaVariantProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListMediaVariantProcessorsController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(MediaVariantRoutes.processorsRoute, use: getMediaVariantProcessors)
        router.get(MediaVariantRoutes.processorAddRoute, use: getAddMediaVariantProcessor)
    }
}
