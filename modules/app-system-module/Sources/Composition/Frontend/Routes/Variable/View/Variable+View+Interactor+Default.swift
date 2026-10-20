import FeatherAdmin
import SystemModule

extension WebAdmin.System.Variable.View.Interactor {
    struct Default:
        WebAdmin.System.Variable.View.Interactor.Interface
    {
        let repository: any WebAdmin.System.Variable.View.Repository.Interface

        func execute(
            entity: WebAdmin.System.Variable.View.Model
        ) async throws -> SystemVariableDetailsModel {
            do {
                return try await repository.get(id: entity.id)
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        private func map(
            _ error: OpenAPIRepositoryError
        ) -> WebAdmin.System.Variable.View.Error {
            switch error {
            case .notFound:
                .notFound
            case .unauthorized:
                .unauthorized
            case .forbidden:
                .forbidden
            case .conflict, .failure, .transport:
                .unavailable
            }
        }
    }
}
