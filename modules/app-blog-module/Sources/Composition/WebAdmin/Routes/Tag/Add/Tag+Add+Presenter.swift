import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension Tag.Add {
    enum Presenter {}
}

extension Tag.Add.Presenter {
    protocol Interface: Sendable {
        func renderAddPage(
            state: BlogTagForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
