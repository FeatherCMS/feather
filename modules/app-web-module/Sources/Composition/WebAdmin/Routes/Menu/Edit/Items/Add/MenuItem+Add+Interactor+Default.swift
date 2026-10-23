import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.Add.Interactor {
    struct Default: Interface {
        let repository: any MenuItem.Add.Repository.Interface
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
}
