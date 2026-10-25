import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.List {
    enum Presenter {
        protocol Interface: Sendable {
            func renderListPage(
                model: Model,
                permissions: Set<String>,
                search: String?,
                error: String?
            ) async throws -> HTMLResponse
        }
    }
}
