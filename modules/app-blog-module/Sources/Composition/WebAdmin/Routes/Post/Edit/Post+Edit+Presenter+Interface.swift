import BlogModule
import FeatherWebAdmin

extension Post.Edit.Presenter {
    protocol Interface: Sendable {
        func render(
            id: String,
            state: Post.Form.State,
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
