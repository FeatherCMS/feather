import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.Detail {
    enum Presenter {}
}

extension Article.Detail.Presenter {
    protocol Interface: Sendable {
        func renderDetails(
            item: Article.Detail.Model
        ) async throws -> HTMLResponse
        func renderError(_ message: String) async throws -> HTMLResponse
    }
}
