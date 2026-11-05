import FeatherWebAdmin
import FeatherWebShared
import RedirectApplication
import RedirectModule

extension Rule.Remove.Interactor {
    struct Default: Interface {
        let repository: any Rule.Remove.Repository.Interface

        func delete(ids: [String]) async throws {
            do { try await repository.delete(ids: ids) }
            catch let error as OpenAPIRepositoryError { throw map(error) }
        }

        private func map(_ error: OpenAPIRepositoryError)
            -> Rule.Remove.Error
        {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .conflict: .conflict
            case .failure(let failure) where failure.statusCode == 409:
                .conflict
            default: .unavailable
            }
        }
    }
}
