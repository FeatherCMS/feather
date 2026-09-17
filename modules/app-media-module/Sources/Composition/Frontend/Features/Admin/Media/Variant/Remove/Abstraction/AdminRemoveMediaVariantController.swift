import FeatherAdmin
import Hummingbird

protocol AdminRemoveMediaVariantController: Sendable {
    func getRemoveMediaVariants(request: Request, context: DefaultRequestContext) async throws -> Response
    func postRemoveMediaVariants(request: Request, context: DefaultRequestContext) async throws -> Response
}

extension AdminRemoveMediaVariantController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(MediaVariantRoutes.remove, use: getRemoveMediaVariants)
        router.post(MediaVariantRoutes.remove, use: postRemoveMediaVariants)
    }
}
