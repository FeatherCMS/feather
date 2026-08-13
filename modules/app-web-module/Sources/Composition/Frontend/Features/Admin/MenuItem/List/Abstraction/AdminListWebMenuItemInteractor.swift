import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebMenuItemInteractor: Sendable {

    func listWebMenuItems(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuItemModel

    func bulkRemove(
        menuId: String,
        ids: [String]
    ) async throws
}
