import FeatherAdmin
import Hummingbird

protocol AdminEditMediaVariantController: Sendable {
    func getEditMediaVariant(request: Request, context: DefaultRequestContext) async throws -> Response
    func postEditMediaVariant(request: Request, context: DefaultRequestContext) async throws -> Response
    func postAddMediaVariantProcessor(request: Request, context: DefaultRequestContext) async throws -> Response
    func postEditMediaVariantProcessor(request: Request, context: DefaultRequestContext) async throws -> Response
    func postRemoveMediaVariantProcessor(request: Request, context: DefaultRequestContext) async throws -> Response
}

extension AdminEditMediaVariantController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(MediaVariantRoutes.editRoute, use: getEditMediaVariant)
        router.post(MediaVariantRoutes.editRoute, use: postEditMediaVariant)
        router.post(MediaVariantRoutes.processorAddRoute, use: postAddMediaVariantProcessor)
        router.post(MediaVariantRoutes.processorEditRoute, use: postEditMediaVariantProcessor)
        router.post(MediaVariantRoutes.processorRemoveRoute, use: postRemoveMediaVariantProcessor)
    }
}
