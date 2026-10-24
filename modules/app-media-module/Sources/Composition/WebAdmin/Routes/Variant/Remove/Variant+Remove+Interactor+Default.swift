import FeatherWebAdmin
import FeatherWebShared
import MediaModule

extension Variant.Remove.Interactor {
    struct Default:
        Variant.Remove.Interactor.Interface
    {
        let repository: any Variant.Remove.Repository.Interface

        func delete(ids: [String]) async throws {
            do { try await repository.delete(ids: ids) }
            catch let error as OpenAPIRepositoryError { throw map(error) }
        }

        private func map(_ error: OpenAPIRepositoryError)
            -> Variant.Remove.Error
        {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .conflict: .unavailable
            case .failure, .transport: .unavailable
            }
        }
    }
}
