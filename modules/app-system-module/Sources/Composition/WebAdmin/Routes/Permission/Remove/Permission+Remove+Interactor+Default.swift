import FeatherWebAdmin
import FeatherWebShared
import SystemModule

extension Permission.Remove.Interactor {
    struct Default:
        Interface
    {
        let repository:
            any Permission.Remove.Repository
                .Interface

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
        ) -> Permission.Remove.Error {
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
