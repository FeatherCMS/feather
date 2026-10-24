import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsAdminAPI
import NewsApplication
import NewsModule

extension Category.Remove {
    enum Presenter {}
}

extension Category.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemoveConfirmation(
            item: Components.Schemas.NewsCategoryDetailSchema
        ) async throws -> Response
        func renderError(_ message: String) async throws -> HTMLResponse
        func renderRemoved() -> Response
    }
}
