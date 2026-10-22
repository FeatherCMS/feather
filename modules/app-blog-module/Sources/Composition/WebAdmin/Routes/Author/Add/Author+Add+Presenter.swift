import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension Author.Add {
    enum Presenter {}
}

extension Author.Add.Presenter {
    protocol Interface: Sendable {
        func render(
            state: BlogAuthorForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
