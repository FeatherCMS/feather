import FeatherAdmin
import Hummingbird

protocol AdminListNewsCategoryController: Sendable {
    func getNewsCategories(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListNewsCategoryController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(NewsAdminRoutes.categories, use: getNewsCategories)
    }
}
