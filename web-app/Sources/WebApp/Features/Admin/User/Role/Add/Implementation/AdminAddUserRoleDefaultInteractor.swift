import Foundation

struct AdminAddUserRoleDefaultInteractor: AdminAddUserRoleInteractor {
    let repository: any AdminAddUserRoleRepository

    func execute(
        entity: AdminAddUserRoleModel
    ) async throws {
        try await repository.create(payload: entity.payload)
    }
}
