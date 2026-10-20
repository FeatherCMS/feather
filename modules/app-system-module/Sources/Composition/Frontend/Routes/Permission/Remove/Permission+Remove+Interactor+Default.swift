import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.Remove.Interactor {
    struct Default:
        WebAdmin.System.Permission.Remove.Interactor.Interface
    {
        let repository:
            any WebAdmin.System.Permission.Remove.Repository.Interface

        func delete(ids: [String]) async throws {
            do {
                for id in ids {
                    try await repository.delete(id: id)
                }
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        private func map(
            _ error: OpenAPIRepositoryError
        ) -> WebAdmin.System.Permission.Remove.Error {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .conflict: .conflict
            case .failure(let failure) where failure.statusCode == 409:
                .conflict
            case .failure, .transport: .unavailable
            }
        }
    }
}
