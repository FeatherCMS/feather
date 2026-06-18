import Foundation

struct AdminGetSystemPermissionDefaultInteractor:
    AdminGetSystemPermissionInteractor
{
    let repository: any AdminGetSystemPermissionRepository

    func execute(
        entity: AdminGetSystemPermissionModel
    ) async throws -> SystemPermissionDetailsModel {
        try await repository.get(id: entity.id)
    }
}
