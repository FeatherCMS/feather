import Hummingbird

struct AdminListWebMenuItemDefaultInteractor:
    AdminListWebMenuItemInteractor
{
    let repository: any AdminListWebMenuItemRepository

    func listWebMenuItems(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuItemModel {
        try await repository.listWebMenuItems(
            menuId: menuId,
            page: page,
            search: search
        )
    }

    func bulkRemove(
        menuId: String,
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(menuId: menuId, id: id)
        }
    }
}
