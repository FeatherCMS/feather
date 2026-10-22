import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension Tag.Edit {
    enum Presenter {}
}

extension Tag.Edit.Presenter {
    protocol Interface: Sendable {
        func render(
            id: String,
            state: BlogTagForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderError(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
