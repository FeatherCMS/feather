import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsAdminAPI
import NewsModule

extension Category.Detail {
    enum Presenter {}
}

extension Category.Detail.Presenter {
    protocol Interface: Sendable {
        func renderDetails(
            item: Components.Schemas.NewsCategoryDetailSchema
        ) async throws -> HTMLResponse
        func renderError(_ message: String) async throws -> HTMLResponse
    }
}
