import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsApplication
import NewsModule

extension Category.List {
    enum Presenter {}
}

extension Category.List.Presenter {
    protocol Interface: Sendable {
        func renderList(
            model: NewsModule.Category.List.Model,
            search: String,
            status: AdminMetadataStatus?,
            error: String?
        ) async throws -> HTMLResponse
    }
}
