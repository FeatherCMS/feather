import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.Add {
    enum Controller {}
}

extension Article.Add.Controller {
    protocol Interface: Sendable {
        func getAddNewsArticle(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddNewsArticle(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
