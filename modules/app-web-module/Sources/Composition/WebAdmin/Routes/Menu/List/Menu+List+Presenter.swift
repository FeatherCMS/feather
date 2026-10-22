import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain

extension WebDomain.Menu.List {
    enum Presenter {
        protocol Interface: Sendable {
            func renderListPage(
                model: WebDomain.Menu.List.Model,
                permissions: Set<String>,
                search: String?,
                error: String?
            ) async throws -> HTMLResponse
        }
    }
}
