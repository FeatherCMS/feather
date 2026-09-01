import FeatherAdmin
import Foundation

struct AdminGetUserIdentityDefaultInteractor: AdminGetUserIdentityInteractor {
    private let repository: any AdminGetUserIdentityRepository
    private let roleRepository: AdminEditUserIdentityRoleOpenAPIRepository

    init(
        repository: any AdminGetUserIdentityRepository,
        roleRepository: AdminEditUserIdentityRoleOpenAPIRepository
    ) {
        self.repository = repository
        self.roleRepository = roleRepository
    }

    func roleNames(for ids: [String]) async throws -> [String] {
        let roleLookup = Dictionary(
            uniqueKeysWithValues: try await roleRepository.list()
                .map {
                    ($0.id, $0.name)
                }
        )
        return ids.compactMap { roleLookup[$0] }
    }

    func execute(
        id: String
    ) async throws -> AdminGetUserIdentityModel {
        let details = try await repository.get(id: id)
        return .init(details: details)
    }
}
