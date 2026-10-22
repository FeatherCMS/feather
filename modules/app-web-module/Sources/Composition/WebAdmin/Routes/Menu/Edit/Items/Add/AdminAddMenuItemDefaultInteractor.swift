import FeatherWebAdmin
import OpenAPIRuntime

struct AdminAddMenuItemDefaultInteractor: AdminAddMenuItemInteractor {
    let repository: any AdminAddMenuItemRepository
    let permissionRepository: any AdminSystemPermissionRepository

    func loadPermissions() async throws -> [String] {
        try await permissionRepository.listNames()
    }

    func execute(
        menuId: String,
        input: MenuItemFormInput
    ) async throws {
        try await repository.create(menuId: menuId, input: input)
    }
}
