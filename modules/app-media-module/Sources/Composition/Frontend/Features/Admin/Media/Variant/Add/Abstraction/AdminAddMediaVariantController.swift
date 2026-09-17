import FeatherAdmin
import Hummingbird

protocol AdminAddMediaVariantController: Sendable {
    func getAddMediaVariant(request: Request, context: DefaultRequestContext) async throws -> HTMLResponse
    func postAddMediaVariant(request: Request, context: DefaultRequestContext) async throws -> Response
}

extension AdminAddMediaVariantController {
    func route(on router: Router<DefaultRequestContext>) {
        router.get(MediaVariantRoutes.add, use: getAddMediaVariant)
        router.post(MediaVariantRoutes.add, use: postAddMediaVariant)
    }
}
