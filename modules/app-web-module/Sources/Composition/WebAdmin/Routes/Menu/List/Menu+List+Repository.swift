import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.List {
    enum Repository {
        protocol Interface: Sendable {
            func listMenus(
                page: Int,
                search: String?
            ) async throws -> Menu.List.Model
        }
    }
}
