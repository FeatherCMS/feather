import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Search {
    enum Presenter {}
}

extension Page.Search.Presenter {
    protocol Interface: Sendable {
        func renderSearchPage(
            model: Page.Search.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse
    }
}
