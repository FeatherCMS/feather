import FeatherWebAdmin
import OpenAPIRuntime

struct AdminViewMenuItemDefaultInteractor: AdminViewMenuItemInteractor {
    let repository: any AdminViewMenuItemRepository

    func execute(
        entity: AdminViewMenuItemModel
    ) async throws -> MenuItemDetailsModel {
        try await repository.get(menuId: entity.menuId, id: entity.id)
    }
}
