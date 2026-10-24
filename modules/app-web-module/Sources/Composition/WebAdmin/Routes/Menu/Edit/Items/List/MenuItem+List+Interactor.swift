import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.List {
    enum Interactor {}
}

extension MenuItem.List.Interactor {
    protocol Interface: Sendable {
        func list(
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
