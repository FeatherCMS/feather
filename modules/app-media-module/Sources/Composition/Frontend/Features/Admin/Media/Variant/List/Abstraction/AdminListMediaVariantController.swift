import FeatherAdmin
import Hummingbird

protocol AdminListMediaVariantController: Sendable {
    func getMediaVariants(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListMediaVariantController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(MediaVariantRoutes.list, use: getMediaVariants)
    }
}
