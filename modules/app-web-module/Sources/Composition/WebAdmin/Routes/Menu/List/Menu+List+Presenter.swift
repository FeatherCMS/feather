import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain

extension Menu.List {
    enum Presenter {}
}

extension Menu.List.Presenter {
    protocol Interface: Sendable {

        func renderListPage(
            model: Menu.List.Model,
            permissions: Set<String>,
            search: String?,
            error: String?
        ) async throws -> HTMLResponse
    }
}
