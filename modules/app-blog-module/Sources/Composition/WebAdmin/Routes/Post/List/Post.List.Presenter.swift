import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension Post.List {
    enum Presenter {}
}

extension Post.List.Presenter {
    protocol Interface: Sendable {
        func render(
            model: Post.List.Model,
            permissions: Set<String>,
            search: String?,
            status: AdminMetadataStatus?,
            error: String?
        ) async throws -> HTMLResponse
    }
}
