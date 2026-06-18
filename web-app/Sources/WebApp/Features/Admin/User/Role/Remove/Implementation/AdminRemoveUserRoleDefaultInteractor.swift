import Foundation

struct AdminRemoveUserRoleDefaultInteractor: AdminRemoveUserRoleInteractor {
    let repository: any AdminRemoveUserRoleRepository

    func get(
        id: String
    ) async throws -> UserRoleDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminRemoveUserRoleModel
    ) async throws {
        try await repository.delete(id: entity.id)
    }
}
