import Hummingbird

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
}
