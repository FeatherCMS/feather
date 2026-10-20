import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.Add.Interactor {
    struct Default:
        WebAdmin.System.Permission.Add.Interactor.Interface
    {
        let repository: any WebAdmin.System.Permission.Add.Repository.Interface

        func execute(
            entity: WebAdmin.System.Permission.Add.Model
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
        ) -> WebAdmin.System.Permission.Add.Error {
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
