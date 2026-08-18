import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

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

    func move(
        menuId: String,
        itemId: String,
        beforeItemId: String?
    ) async throws {
        try await repository.move(
            menuId: menuId,
            itemId: itemId,
            beforeItemId: beforeItemId
        )
    }
}
