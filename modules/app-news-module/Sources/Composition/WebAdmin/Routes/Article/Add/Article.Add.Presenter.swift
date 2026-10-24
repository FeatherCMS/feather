import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.Add {
    enum Presenter {}
}

extension Article.Add.Presenter {
    protocol Interface: Sendable {
        func renderForm(
            input: Article.Form.Input,
            categories: [Article.Form.CategoryOption],
            error: String?,
            title: String,
            action: String,
            submitLabel: String,
            removeHref: String?
        ) async throws -> HTMLResponse
        func renderCreated() -> Response
    }
}
