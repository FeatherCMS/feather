import FeatherWebAdmin
import FeatherWebShared
import SystemModule

extension Variable.View.Interactor {
    struct Default:
        Interface
    {
        let repository: any Variable.View.Repository.Interface

        func execute(
            entity: Variable.View.Model
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
        ) -> Variable.View.Error {
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
