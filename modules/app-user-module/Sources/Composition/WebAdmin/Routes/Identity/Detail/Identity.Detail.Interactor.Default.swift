import FeatherWebAdmin
import FeatherWebShared
import UserModule

extension Identity.Detail.Interactor {
    struct Default: Interface {
        private let repository: any Identity.Detail.Repository.Interface
        private let roleRepository:
            any Identity.Detail.Repository.Role.Interface

        init(
            repository: any Identity.Detail.Repository.Interface,
            roleRepository: any Identity.Detail.Repository.Role.Interface
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
        ) async throws -> Identity.Detail.Repository.Model {
            do {
                return try await repository.load(id: id)
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        private func map(_ error: OpenAPIRepositoryError)
            -> Identity.Detail.Error
        {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            default: .unavailable
            }
        }
    }
}
