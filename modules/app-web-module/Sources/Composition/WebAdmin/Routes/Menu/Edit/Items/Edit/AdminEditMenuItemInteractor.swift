import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminEditMenuItemInteractor: Sendable {

    func loadPermissions() async throws -> [String]

    func load(
        menuId: String,
        id: String
    ) async throws -> MenuItemDetailsModel

    func update(
        menuId: String,
        id: String,
        input: MenuItemFormInput
    ) async throws
}
