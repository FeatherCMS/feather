import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminListMenuItemDefaultInteractor:
    AdminListMenuItemInteractor
{
    let repository: any AdminListMenuItemRepository

    func listMenuItems(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListMenuItemModel {
        try await repository.listMenuItems(
            menuId: menuId,
            page: page,
            search: search
        )
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
