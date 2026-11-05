import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.Edit {
    enum Presenter {}
}

extension Category.Edit.Presenter {
    protocol Interface: Sendable {
        func renderForm(
            input: Category.Form.Input,
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
