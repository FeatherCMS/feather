import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension Tag.List.Presenter {
    protocol Interface: Sendable {
        func render(
            model: Tag.List.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse
    }
}
