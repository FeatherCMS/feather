import FeatherWebAdmin
import FeatherWebShared
import UserModule

extension Role.Remove.Interactor {
    struct Default: Interface {
        let repository: any Role.Remove.Repository.Interface

        func delete(
            ids: [String]
        ) async throws {
            do { try await repository.delete(ids: ids) }
            catch let error as OpenAPIRepositoryError { throw map(error) }
        }

        private func map(_ error: OpenAPIRepositoryError)
            -> Role.Remove.Error
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
