import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension Author.Add.Presenter {
    protocol Interface: Sendable {
        func render(
            state: Author.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
