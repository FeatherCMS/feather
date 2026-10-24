import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension Author.Edit {
    enum Presenter {}
}

extension Author.Edit.Presenter {
    protocol Interface: Sendable {
        func render(
            id: String,
            state: Author.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderError(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
