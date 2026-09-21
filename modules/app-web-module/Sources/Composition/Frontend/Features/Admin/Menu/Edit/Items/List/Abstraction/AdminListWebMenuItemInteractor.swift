import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuItemInteractor: Sendable {

    func listWebMenuItems(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuItemModel

    func remove(
        menuId: String,
        ids: [String]
    ) async throws

    func move(
        menuId: String,
        itemId: String,
        beforeItemId: String?
    ) async throws
}
