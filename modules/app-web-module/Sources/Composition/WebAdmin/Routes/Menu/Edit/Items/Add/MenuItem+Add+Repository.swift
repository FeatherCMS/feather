import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.Add {
    enum Repository {}
}

extension MenuItem.Add.Repository {
    protocol Interface: Sendable {
        func create(
            menuId: String,
            input: MenuItemFormInput
        ) async throws
    }
}
