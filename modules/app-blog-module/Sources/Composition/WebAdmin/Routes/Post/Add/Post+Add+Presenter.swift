import BlogModule
import FeatherWebAdmin

extension Post.Add {
    enum Presenter {}
}

extension Post.Add.Presenter {
    protocol Interface: Sendable {
        func render(
            state: BlogPostForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
