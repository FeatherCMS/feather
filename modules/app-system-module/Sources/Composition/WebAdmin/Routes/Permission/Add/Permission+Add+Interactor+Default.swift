import FeatherAdmin
import Hummingbird
import SystemModule

extension Permission.Add.Interactor {
    struct Default:
        Interface
    {
        let repository: any Permission.Add.Repository.Interface

        func execute(
            entity: Permission.Add.Model
        ) async throws {
            do {
                try await repository.create(entity: entity)
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        private func map(
            _ error: OpenAPIRepositoryError
        ) -> Permission.Add.Error {
            switch error {
            case .unauthorized:
                .unauthorized
            case .forbidden:
                .forbidden
            case .conflict:
                .conflict
            case .failure(let failure) where failure.statusCode == 409:
                .conflict
            case .failure, .transport, .notFound:
                .unavailable
            }
        }
    }
}
