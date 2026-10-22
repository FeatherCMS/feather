import FeatherWebAdmin
import OpenAPIRuntime

struct AdminEditMenuItemDefaultInteractor:
    AdminEditMenuItemInteractor
{
    let repository: any AdminEditMenuItemRepository
    let permissionRepository: any AdminSystemPermissionRepository

    func loadPermissions() async throws -> [String] {
        try await permissionRepository.listNames()
    }

    func load(
        menuId: String,
        id: String
    ) async throws -> MenuItemDetailsModel {
        try await repository.load(menuId: menuId, id: id)
    }

    func update(
        menuId: String,
        id: String,
        input: MenuItemFormInput
    ) async throws {
        try await repository.update(menuId: menuId, id: id, input: input)
    }
}
