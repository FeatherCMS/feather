import FeatherAdmin
import Hummingbird

protocol AdminViewNewsCategoryController: Sendable {
    func getNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewNewsCategoryController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            NewsAdminRoutes.category(RouterPath("{id}")),
            use: getNewsCategory
        )
    }
}
