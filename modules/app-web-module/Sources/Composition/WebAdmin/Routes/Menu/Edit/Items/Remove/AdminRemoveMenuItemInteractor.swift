import FeatherWebAdmin
import OpenAPIRuntime

protocol AdminRemoveMenuItemInteractor: Sendable {

    func get(
        menuId: String,
        id: String
    ) async throws -> MenuItemDetailsModel

    func delete(
        menuId: String,
        id: String
    ) async throws

    func delete(
        menuId: String,
        ids: [String]
    ) async throws
}
