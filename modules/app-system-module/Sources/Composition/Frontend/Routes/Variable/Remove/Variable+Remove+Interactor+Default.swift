import FeatherAdmin
import SystemModule

extension WebAdmin.System.Variable.Remove.Interactor {
    struct Default:
        WebAdmin.System.Variable.Remove.Interactor.Interface
    {
        let repository: any WebAdmin.System.Variable.Remove.Repository.Interface

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
        ) -> WebAdmin.System.Variable.Remove.Error {
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
