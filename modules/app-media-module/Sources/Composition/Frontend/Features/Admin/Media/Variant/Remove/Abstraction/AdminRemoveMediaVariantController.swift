import FeatherAdmin
import Hummingbird

protocol AdminRemoveMediaVariantController: Sendable {
    func getRemoveMediaVariants(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
    func postRemoveMediaVariants(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveMediaVariantController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(MediaVariantRoutes.remove, use: getRemoveMediaVariants)
        router.post(MediaVariantRoutes.remove, use: postRemoveMediaVariants)
    }
}
