import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Article.Edit {
    enum Presenter {}
}

extension Article.Edit.Presenter {
    protocol Interface: Sendable {
        func renderForm(
            input: Article.Form.Input,
            categories: [Article.Form.CategoryOption],
            error: String?,
            title: String,
            action: String,
            submitLabel: String,
            moreActions: [AdminButton.State]
        ) async throws -> HTMLResponse
        func renderError(_ message: String) async throws -> HTMLResponse
        func renderUpdated(id: String) -> Response
    }
}
