import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.Detail {
    enum Controller {}
}

extension Article.Detail.Controller {
    protocol Interface: Sendable {
        func getNewsArticle(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
