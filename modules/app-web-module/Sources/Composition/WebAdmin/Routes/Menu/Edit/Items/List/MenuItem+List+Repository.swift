import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.List {
    enum Repository {}
}

extension MenuItem.List.Repository {
    protocol Interface: Sendable {
        func listMenuItems(
            menuId: String,
            page: Int,
            search: String?
        ) async throws -> MenuItem.List.Model

        func move(
            menuId: String,
            itemId: String,
            beforeItemId: String?
        ) async throws
    }
}
