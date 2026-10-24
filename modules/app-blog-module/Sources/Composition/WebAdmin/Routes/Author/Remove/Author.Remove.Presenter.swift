import BlogModule
import FeatherWebAdmin
import FeatherWebShared

extension Author.Remove {
    enum Presenter {}
}

extension Author.Remove.Presenter {
    protocol Interface: Sendable {
        func renderError(info: String, message: String) async throws
            -> HTMLResponse
    }
}
