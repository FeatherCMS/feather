import FeatherWebAdmin
import Hummingbird

protocol AdminRemoveNewsArticleController: Sendable {
    func postRemoveNewsArticle(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveNewsArticleController {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
    }
}
