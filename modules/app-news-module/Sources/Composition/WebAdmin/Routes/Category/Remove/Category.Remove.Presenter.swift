import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.Remove {
    enum Presenter {}
}

extension Category.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemoveConfirmation(
            item: Category.Detail.Model
        ) async throws -> Response
        func renderError(_ message: String) async throws -> HTMLResponse
        func renderRemoved() -> Response
    }
}
