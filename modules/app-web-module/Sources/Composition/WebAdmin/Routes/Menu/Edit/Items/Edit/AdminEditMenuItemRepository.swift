import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminEditMenuItemRepository: Sendable {

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
