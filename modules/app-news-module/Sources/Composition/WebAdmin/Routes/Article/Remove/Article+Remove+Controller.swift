import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.Remove {
    enum Controller {}
}

extension Article.Remove.Controller {
    protocol Interface: Sendable {
        func getRemoveNewsArticle(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response

        func postRemoveNewsArticle(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
