import Foundation

struct AdminEditUserRoleDefaultInteractor: AdminEditUserRoleInteractor {
    let repository: any AdminEditUserRoleRepository

    func get(
        id: String
    ) async throws -> UserRoleDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminEditUserRoleModel
    ) async throws {
        try await repository.update(id: entity.id, payload: entity.payload)
    }
}
