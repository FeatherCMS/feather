import FeatherAdmin
import Hummingbird

protocol AdminViewNewsArticleController: Sendable {
    func getNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewNewsArticleController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            NewsAdminRoutes.article(RouterPath("{id}")),
            use: getNewsArticle
        )
    }
}
