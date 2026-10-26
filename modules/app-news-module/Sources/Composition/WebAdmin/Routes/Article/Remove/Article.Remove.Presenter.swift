import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.Remove {
    enum Presenter {}
}

extension Article.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemoveConfirmation(
            item: Article.Detail.Model
        ) async throws -> Response
        func renderError(_ message: String) async throws -> HTMLResponse
        func renderRemoved() -> Response
    }
}
