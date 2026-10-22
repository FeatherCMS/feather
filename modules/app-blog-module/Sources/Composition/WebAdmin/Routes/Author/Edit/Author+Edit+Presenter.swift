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
            state: BlogAuthorForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderError(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
