import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.Edit {
    enum Controller {}
}

extension Article.Edit.Controller {
    protocol Interface: Sendable {
        func getEditNewsArticle(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postEditNewsArticle(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
