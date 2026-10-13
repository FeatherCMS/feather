import FeatherAdmin
import Hummingbird

protocol AdminListMediaVariantController: Sendable {
    func getMediaVariants(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListMediaVariantController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(MediaVariantRoutes.list, use: getMediaVariants)
    }
}
