import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.View.Interactor {
    struct Default:
        WebAdmin.System.Permission.View.Interactor.Interface
    {
        let repository: any WebAdmin.System.Permission.View.Repository.Interface

        func execute(
            entity: WebAdmin.System.Permission.View.Model
        ) async throws -> SystemPermissionDetailsModel {
            do {
                return try await repository.get(id: entity.id)
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .notFound:
                    throw WebAdmin.System.Permission.View.Error.notFound
                case .unauthorized:
                    throw WebAdmin.System.Permission.View.Error.unauthorized
                case .forbidden:
                    throw WebAdmin.System.Permission.View.Error.forbidden
                case .failure, .transport, .conflict:
                    throw WebAdmin.System.Permission.View.Error.unavailable
                }
            }
        }
    }
}
