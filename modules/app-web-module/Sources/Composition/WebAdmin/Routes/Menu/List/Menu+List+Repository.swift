import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.List {
    enum Repository {
        protocol Interface: Sendable {
            func search(
                page: Int,
                search: String?
            ) async throws -> WebModule.Menu.List.Model
        }
    }
}
