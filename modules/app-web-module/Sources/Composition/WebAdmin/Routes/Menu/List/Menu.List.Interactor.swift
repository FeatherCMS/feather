import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.List {
    enum Interactor {
        protocol Interface: Sendable {
            func listMenus(
                page: Int,
                search: String?
            ) async throws -> WebModule.Menu.List.Model
        }
    }
}
