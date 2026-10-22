import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListMenuItemInteractor: Sendable {

    func listMenuItems(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListMenuItemModel

    func move(
        menuId: String,
        itemId: String,
        beforeItemId: String?
    ) async throws
}
