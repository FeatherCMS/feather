import FeatherAdmin
import Hummingbird

protocol AdminRemoveNewsCategoryController: Sendable {
    func postRemoveNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveNewsCategoryController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post(
            NewsAdminRoutes.categoryRemove(RouterPath("{id}")),
            use: postRemoveNewsCategory
        )
    }
}
