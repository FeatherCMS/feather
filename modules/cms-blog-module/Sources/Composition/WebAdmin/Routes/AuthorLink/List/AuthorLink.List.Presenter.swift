import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension AuthorLink.List {
    enum Presenter {}
}

extension AuthorLink.List.Presenter {
    protocol Interface: Sendable {
        func render(
            authorID: String,
            model: AuthorLink.List.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse
    }
}
