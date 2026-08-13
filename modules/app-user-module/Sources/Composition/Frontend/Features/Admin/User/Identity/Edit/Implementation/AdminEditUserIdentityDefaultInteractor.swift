import FeatherAdmin
import Foundation

struct AdminEditUserIdentityDefaultInteractor: AdminEditUserIdentityInteractor {
    let identityRepository: any AdminEditUserIdentityRepository
    let roleRepository: any AdminEditUserIdentityRoleRepository

    func loadIdentity(
        id: String
    ) async throws -> AdminEditUserIdentityModel {
        try await identityRepository.get(id: id)
    }

    func loadRoleOptions() async throws
        -> [AdminEditUserIdentityRoleOptionModel]
    {
        try await roleRepository.list()
    }

    func update(
        entity: AdminEditUserIdentityModel
    ) async throws {
        try await identityRepository.update(
            id: entity.id,
            payload: entity.payload
        )
    }
}
