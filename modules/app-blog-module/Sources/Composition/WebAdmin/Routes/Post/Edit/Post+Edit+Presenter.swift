import BlogModule
import FeatherWebAdmin

extension Post.Edit {
    enum Presenter {}
}

extension Post.Edit.Presenter {
    protocol Interface: Sendable {
        func render(
            id: String,
            state: BlogPostForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderError(
            id: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
