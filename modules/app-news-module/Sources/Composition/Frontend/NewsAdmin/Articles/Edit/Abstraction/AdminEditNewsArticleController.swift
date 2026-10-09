import FeatherAdmin
import Hummingbird

protocol AdminEditNewsArticleController: Sendable {
    func getEditNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditNewsArticleController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            NewsAdminRoutes.articleEdit(RouterPath("{id}")),
            use: getEditNewsArticle
        )
        router.post(
            NewsAdminRoutes.articleEdit(RouterPath("{id}")),
            use: postEditNewsArticle
        )
    }
}
