import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.List {
    enum Presenter {}
}

extension Article.List.Presenter {
    protocol Interface: Sendable {
        func renderList(
            model: Article.List.Model,
            search: String,
            error: String?
        ) async throws -> HTMLResponse
    }
}
