import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct AdminEditWebMenuItemDefaultInteractor:
    AdminEditWebMenuItemInteractor
{
    let repository: any AdminEditWebMenuItemRepository
    let permissionRepository: any AdminSystemPermissionRepository

    func loadPermissions(
    ) async throws -> [String] {
        try await permissionRepository.listNames()
    }

    func load(
        menuId: String,
        id: String
    ) async throws -> WebMenuItemDetailsModel {
        try await repository.load(menuId: menuId, id: id)
    }

    func update(
        menuId: String,
        id: String,
        input: WebMenuItemFormInput
    ) async throws {
        try await repository.update(menuId: menuId, id: id, input: input)
    }
}
