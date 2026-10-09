import FeatherAdmin
import Hummingbird

protocol AdminAddNewsCategoryController: Sendable {
    func getAddNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddNewsCategoryController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(NewsAdminRoutes.categoryAdd(), use: getAddNewsCategory)
        router.post(NewsAdminRoutes.categoryAdd(), use: postAddNewsCategory)
    }
}
