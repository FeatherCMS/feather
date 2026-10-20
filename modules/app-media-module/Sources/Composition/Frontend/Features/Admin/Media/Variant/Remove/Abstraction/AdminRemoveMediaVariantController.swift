import FeatherWebAdmin
import Hummingbird

protocol AdminRemoveMediaVariantController: Sendable {
    func postRemoveMediaVariants(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveMediaVariantController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(MediaVariantRoutes.remove, use: postRemoveMediaVariants)
    }
}
