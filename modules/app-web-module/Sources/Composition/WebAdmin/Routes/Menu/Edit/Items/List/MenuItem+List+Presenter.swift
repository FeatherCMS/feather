import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.List {
    enum Presenter {}
}

extension MenuItem.List.Presenter {
    protocol Interface: Sendable {
        func renderListPage(
            menuId: String,
            model: Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse
    }
}
