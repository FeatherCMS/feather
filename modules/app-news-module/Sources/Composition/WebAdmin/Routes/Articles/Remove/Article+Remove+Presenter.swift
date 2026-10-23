import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsAdminAPI
import NewsModule

extension Article.Remove {
    enum Presenter {}
}

extension Article.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemoveConfirmation(
            item: Components.Schemas.NewsArticleDetailSchema
        ) async throws -> Response
        func renderError(_ message: String) async throws -> HTMLResponse
        func renderRemoved() -> Response
    }
}
