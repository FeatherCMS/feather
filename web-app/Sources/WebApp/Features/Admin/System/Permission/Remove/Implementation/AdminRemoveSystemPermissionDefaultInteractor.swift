import Foundation

struct AdminRemoveSystemPermissionDefaultInteractor:
    AdminRemoveSystemPermissionInteractor
{
    let repository: any AdminRemoveSystemPermissionRepository

    func get(
        id: String
    ) async throws -> SystemPermissionDetailsModel {
        try await repository.get(id: id)
    }

    func delete(
        id: String
    ) async throws {
        try await repository.delete(id: id)
    }
}
