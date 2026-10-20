import FeatherWebAdmin
import UserModule

extension Identity.Remove.Interactor {
    struct Default: Interface {
        private let repository: any Identity.Remove.Repository.Interface

        init(repository: any Identity.Remove.Repository.Interface) {
            self.repository = repository
        }

        func delete(
            ids: [String]
        ) async throws {
            do { try await repository.delete(ids: ids) }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        private func map(_ error: OpenAPIRepositoryError)
            -> Identity.Remove.Error
        {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .conflict: .conflict
            default: .unavailable
            }
        }
    }
}
