import FeatherAdmin
import Hummingbird

protocol AdminRemoveNewsArticleController: Sendable {
    func getRemoveNewsArticleConfirmation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postRemoveNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveNewsArticleController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            NewsAdminRoutes.articleRemove(RouterPath("{id}")),
            use: getRemoveNewsArticleConfirmation
        )
        router.post(
            NewsAdminRoutes.articleRemove(RouterPath("{id}")),
            use: postRemoveNewsArticle
        )
    }
}
