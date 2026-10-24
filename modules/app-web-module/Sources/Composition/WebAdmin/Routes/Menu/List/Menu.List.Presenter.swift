import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.List {
    enum Presenter {
        protocol Interface: Sendable {
            func renderListPage(
                model: WebModule.Menu.List.Model,
                permissions: Set<String>,
                search: String?,
                error: String?
            ) async throws -> HTMLResponse
        }
    }
}
