import FeatherAdmin
import Hummingbird

protocol AdminAddMediaVariantController: Sendable {
    func getAddMediaVariant(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    func postAddMediaVariant(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
}

extension AdminAddMediaVariantController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(MediaVariantRoutes.add, use: getAddMediaVariant)
        router.post(MediaVariantRoutes.add, use: postAddMediaVariant)
    }
}
