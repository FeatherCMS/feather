import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminViewMenuItemRepository: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> MenuItemDetailsModel
}
