import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.Add {
    enum Interactor {}
}

extension MenuItem.Add.Interactor {
    protocol Interface: Sendable {
        func loadPermissions() async throws -> [String]

        func execute(
            menuId: String,
            input: MenuItemFormInput
        ) async throws
    }
}
