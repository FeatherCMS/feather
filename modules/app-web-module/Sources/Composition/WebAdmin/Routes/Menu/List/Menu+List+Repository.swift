import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain

extension WebDomain.Menu.List {
    enum Repository {
        protocol Interface: Sendable {
            func listMenus(
                page: Int,
                search: String?
            ) async throws -> WebDomain.Menu.List.Model
        }
    }
}
