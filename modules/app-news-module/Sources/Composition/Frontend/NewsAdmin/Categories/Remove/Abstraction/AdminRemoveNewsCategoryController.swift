import FeatherAdmin
import Hummingbird

protocol AdminRemoveNewsCategoryController: Sendable {
    func getRemoveNewsCategoryConfirmation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postRemoveNewsCategory(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveNewsCategoryController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            NewsAdminRoutes.categoryRemove(RouterPath("{id}")),
            use: getRemoveNewsCategoryConfirmation
        )
        router.post(
            NewsAdminRoutes.categoryRemove(RouterPath("{id}")),
            use: postRemoveNewsCategory
        )
    }
}
