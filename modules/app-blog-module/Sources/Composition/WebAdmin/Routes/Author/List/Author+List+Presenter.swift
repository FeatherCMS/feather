import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension Author.List {
    enum Presenter {}
}

extension Author.List.Presenter {
    protocol Interface: Sendable {
        func render(
            model: Author.List.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse
    }
}
