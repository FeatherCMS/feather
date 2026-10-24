import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsModule

extension Article.List {
    enum Controller {}
}

extension Article.List.Controller {
    protocol Interface: Sendable {
        func getArticles(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
