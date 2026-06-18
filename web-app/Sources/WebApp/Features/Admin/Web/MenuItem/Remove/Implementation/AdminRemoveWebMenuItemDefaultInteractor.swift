import Foundation

struct AdminRemoveWebMenuItemDefaultInteractor:
    AdminRemoveWebMenuItemInteractor
{
    let repository: any AdminRemoveWebMenuItemRepository

    func get(
        menuId: String,
        id: String
    ) async throws -> WebMenuItemDetailsModel {
        try await repository.get(menuId: menuId, id: id)
    }

    func delete(
        menuId: String,
        id: String
    ) async throws {
        try await repository.delete(menuId: menuId, id: id)
    }
}
