import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension MenuItem.Edit.Interactor {
    struct Default: Interface {
        let repository: any MenuItem.Edit.Repository.Interface
        let permissionRepository: any AdminSystemPermissionRepository

    func loadPermissions() async throws -> [String] {
        try await permissionRepository.listNames()
    }

    func load(
        menuId: String,
        id: String
    ) async throws -> MenuItem.View.Model {
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
}
