import FeatherAdmin
import Hummingbird

protocol AdminListNewsArticleController: Sendable {
    func getNewsArticles(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminListNewsArticleController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(NewsAdminRoutes.articles, use: getNewsArticles)
    }
}
