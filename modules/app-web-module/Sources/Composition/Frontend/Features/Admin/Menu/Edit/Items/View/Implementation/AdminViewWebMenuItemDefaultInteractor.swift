import FeatherAdmin
import OpenAPIRuntime

struct AdminViewWebMenuItemDefaultInteractor: AdminViewWebMenuItemInteractor {
    let repository: any AdminViewWebMenuItemRepository

    func execute(
        entity: AdminViewWebMenuItemModel
    ) async throws -> WebMenuItemDetailsModel {
        try await repository.get(menuId: entity.menuId, id: entity.id)
    }
}
