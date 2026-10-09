import FeatherAdmin
import Hummingbird

protocol AdminEditNewsCategoryController: Sendable {
    func getEditNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditNewsCategoryController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            NewsAdminRoutes.categoryEdit(RouterPath("{id}")),
            use: getEditNewsCategory
        )
        router.post(
            NewsAdminRoutes.categoryEdit(RouterPath("{id}")),
            use: postEditNewsCategory
        )
    }
}
