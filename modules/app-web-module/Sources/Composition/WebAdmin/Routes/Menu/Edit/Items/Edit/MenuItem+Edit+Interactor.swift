import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.Edit {
    enum Interactor {}
}

extension MenuItem.Edit.Interactor {
    protocol Interface: Sendable {
        func loadPermissions() async throws -> [String]

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
