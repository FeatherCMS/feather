import FeatherAdmin
import Foundation

struct AdminViewUserIdentityDefaultInteractor: AdminViewUserIdentityInteractor {
    private let repository: any AdminViewUserIdentityRepository
    private let roleRepository: any AdminViewUserIdentityRoleRepository

    init(
        repository: any AdminViewUserIdentityRepository,
        roleRepository: any AdminViewUserIdentityRoleRepository
    ) {
        self.repository = repository
        self.roleRepository = roleRepository
    }

    func roleNames(for ids: [String]) async throws -> [String] {
        do { return try await roleRepository.names(for: ids) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func load(
        id: String
    ) async throws -> AdminViewUserIdentityModel {
        do {
            return .init(details: try await repository.load(id: id))
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(_ error: OpenAPIRepositoryError)
        -> AdminViewUserIdentityError
    {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        default: .unavailable
        }
    }
}
