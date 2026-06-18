import Foundation

struct AdminGetWebMenuItemDefaultInteractor: AdminGetWebMenuItemInteractor {
    let repository: any AdminGetWebMenuItemRepository

    func execute(
        entity: AdminGetWebMenuItemModel
    ) async throws -> WebMenuItemDetailsModel {
        try await repository.get(menuId: entity.menuId, id: entity.id)
    }
}
