import Foundation

struct AdminGetUserRoleDefaultInteractor: AdminGetUserRoleInteractor {
    let repository: any AdminGetUserRoleRepository

    func execute(
        entity: AdminGetUserRoleModel
    ) async throws -> UserRoleDetailsModel {
        try await repository.get(id: entity.id)
    }
}
