import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.Detail {
    enum Presenter {}
}

extension Category.Detail.Presenter {
    protocol Interface: Sendable {
        func renderDetails(
            item: Category.Detail.Model
        ) async throws -> HTMLResponse
        func renderError(_ message: String) async throws -> HTMLResponse
    }
}
