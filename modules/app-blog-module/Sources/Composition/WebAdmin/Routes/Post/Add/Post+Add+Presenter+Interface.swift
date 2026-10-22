import BlogModule
import FeatherWebAdmin

extension Post.Add.Presenter {
    protocol Interface: Sendable {
        func render(
            state: Post.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
