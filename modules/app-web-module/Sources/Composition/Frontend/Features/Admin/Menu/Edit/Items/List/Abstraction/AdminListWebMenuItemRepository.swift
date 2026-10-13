import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuItemRepository: Sendable {

    func listWebMenuItems(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuItemModel

    func delete(
        menuId: String,
        id: String
    ) async throws

    func move(
        menuId: String,
        itemId: String,
        beforeItemId: String?
    ) async throws
}
