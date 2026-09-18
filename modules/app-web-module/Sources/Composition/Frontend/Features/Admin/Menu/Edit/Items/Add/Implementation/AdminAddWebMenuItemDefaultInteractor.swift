import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct AdminAddWebMenuItemDefaultInteractor: AdminAddWebMenuItemInteractor {
    let repository: any AdminAddWebMenuItemRepository
    let permissionRepository: any AdminSystemPermissionRepository

    func loadPermissions() async throws -> [String] {
        try await permissionRepository.listNames()
    }

    func execute(
        menuId: String,
        input: WebMenuItemFormInput
    ) async throws {
        try await repository.create(menuId: menuId, input: input)
    }
}
