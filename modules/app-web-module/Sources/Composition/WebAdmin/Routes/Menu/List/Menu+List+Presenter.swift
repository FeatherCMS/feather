import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.List {
    enum Presenter {
        protocol Interface: Sendable {
            func renderListPage(
                model: Menu.List.Model,
                permissions: Set<String>,
                search: String?,
                error: String?
            ) async throws -> HTMLResponse
        }
    }
}
