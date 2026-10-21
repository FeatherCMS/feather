import FeatherWebAdmin
import FeatherWebShared
import SystemModule

extension Permission.View.Interactor {
    struct Default:
        Interface
    {
        let repository:
            any Permission.View.Repository
                .Interface

        func execute(
            entity: Permission.View.Model
        ) async throws -> SystemPermissionDetailsModel {
            do {
                return try await repository.get(id: entity.id)
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .notFound:
                    throw Permission.View.Error
                        .notFound
                case .unauthorized:
                    throw Permission.View.Error
                        .unauthorized
                case .forbidden:
                    throw Permission.View.Error
                        .forbidden
                case .failure, .transport, .conflict:
                    throw Permission.View.Error
                        .unavailable
                }
            }
        }
    }
}
