import FeatherWebAdmin
import OpenAPIRuntime

struct AdminRemoveMenuItemDefaultInteractor:
    AdminRemoveMenuItemInteractor
{
    let repository: any AdminRemoveMenuItemRepository

    func get(
        menuId: String,
        id: String
    ) async throws -> MenuItemDetailsModel {
        try await repository.get(menuId: menuId, id: id)
    }

    func delete(
        menuId: String,
        id: String
    ) async throws {
        try await repository.delete(menuId: menuId, id: id)
    }

    func delete(menuId: String, ids: [String]) async throws {
        for id in ids {
            try await repository.delete(menuId: menuId, id: id)
        }
    }
}
