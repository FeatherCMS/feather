import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.Edit {
    enum Repository {}
}

extension MenuItem.Edit.Repository {
    protocol Interface: Sendable {
        func load(
            menuId: String,
            id: String
        ) async throws -> MenuItem.View.Model

        func update(
            menuId: String,
            id: String,
            input: MenuItemFormInput
        ) async throws
    }
}
