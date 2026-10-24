import FeatherWebAdmin
import FeatherWebShared
import SystemModule

extension Variable.Remove.Interactor {
    struct Default:
        Interface
    {
        let repository:
            any Variable.Remove.Repository
                .Interface

        func delete(
            ids: [String]
        ) async throws {
            do {
                try await repository.delete(ids: ids)
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        private func map(
            _ error: OpenAPIRepositoryError
        ) -> Variable.Remove.Error {
            switch error {
            case .notFound:
                .notFound
            case .unauthorized:
                .unauthorized
            case .forbidden:
                .forbidden
            case .conflict:
                .conflict
            case .failure(let failure) where failure.statusCode == 409:
                .conflict
            case .failure, .transport:
                .unavailable
            }
        }
    }
}
