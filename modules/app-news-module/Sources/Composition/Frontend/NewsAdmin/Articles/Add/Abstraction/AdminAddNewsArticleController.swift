import FeatherAdmin
import Hummingbird

protocol AdminAddNewsArticleController: Sendable {
    func getAddNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddNewsArticleController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(NewsAdminRoutes.articleAdd(), use: getAddNewsArticle)
        router.post(NewsAdminRoutes.articleAdd(), use: postAddNewsArticle)
    }
}
