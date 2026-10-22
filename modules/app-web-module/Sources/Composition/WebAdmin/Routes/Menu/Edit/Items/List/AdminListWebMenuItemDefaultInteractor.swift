import FeatherWebAdmin
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
