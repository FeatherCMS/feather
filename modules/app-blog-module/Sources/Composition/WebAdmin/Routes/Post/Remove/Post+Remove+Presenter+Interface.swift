import BlogModule
import FeatherWebAdmin

extension Post.Remove.Presenter {
    protocol Interface: Sendable {
        func renderError(
            id: String,
            info: String,
            message: String
        ) async throws -> HTMLResponse
    }
}
