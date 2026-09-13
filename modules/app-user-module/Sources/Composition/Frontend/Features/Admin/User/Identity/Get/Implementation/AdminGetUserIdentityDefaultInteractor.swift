import FeatherAdmin
import Foundation

struct AdminGetUserIdentityDefaultInteractor: AdminGetUserIdentityInteractor {
    private let repository: any AdminGetUserIdentityRepository
    private let roleRepository: any AdminUserIdentityRoleRepository

    init(
        repository: any AdminGetUserIdentityRepository,
        roleRepository: any AdminUserIdentityRoleRepository
    ) {
        self.repository = repository
        self.roleRepository = roleRepository
    }

    func roleNames(for ids: [String]) async throws -> [String] {
        do {
            let roleLookup = try await roleRepository.list().reduce(into: [String: String]()) {
                $0[$1.id] = $1.name
            }
            return ids.compactMap { roleLookup[$0] }
        } catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    func load(
        id: String
    ) async throws -> AdminGetUserIdentityModel {
        do {
            return .init(details: try await repository.load(id: id))
        } catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(_ error: OpenAPIRepositoryError) -> AdminGetUserIdentityError {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        default: .unavailable
        }
    }
}
