import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension Tag.Add.Presenter {
    protocol Interface: Sendable {
        func renderAddPage(
            state: Tag.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
