import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminRemoveMenuItemRepository: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> MenuItemDetailsModel

    func delete(
        menuId: String,
        id: String
    ) async throws
}
