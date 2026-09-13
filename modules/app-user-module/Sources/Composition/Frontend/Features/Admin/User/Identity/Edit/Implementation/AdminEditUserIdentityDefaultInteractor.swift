import FeatherAdmin
import Foundation

struct AdminEditUserIdentityDefaultInteractor: AdminEditUserIdentityInteractor {
    let identityRepository: any AdminEditUserIdentityRepository
    let roleRepository: any AdminUserIdentityRoleRepository

    func load(
        id: String
    ) async throws -> AdminEditUserIdentityModel {
        do { return try await identityRepository.load(id: id) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func loadRoleOptions() async throws
        -> [UserIdentityRoleOptionModel]
    {
        do { return try await roleRepository.list() }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func edit(
        id: String,
        input: AdminEditUserIdentityFormInput
    ) async throws {
        do {
            try await identityRepository.update(
                id: id,
                payload: .init(
                    name: input.normalizedName,
                    status: input.normalizedStatus,
                    roleIds: input.roleIds ?? []
                )
            )
        }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    private func map(_ error: OpenAPIRepositoryError) -> AdminEditUserIdentityError {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .conflict
        default: .unavailable
        }
    }
}
