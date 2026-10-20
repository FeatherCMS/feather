import FeatherAdmin
import SystemModule

extension WebAdmin.System.Job.View.Interactor {
    struct Default: WebAdmin.System.Job.View.Interactor.Interface {
        let repository: any WebAdmin.System.Job.View.Repository.Interface

        func execute(entity: WebAdmin.System.Job.View.Model) async throws
            -> SystemJobDetailsModel
        {
            do {
                return try await repository.get(id: entity.id)
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .notFound: throw WebAdmin.System.Job.View.Error.notFound
                case .unauthorized:
                    throw WebAdmin.System.Job.View.Error.unauthorized
                case .forbidden: throw WebAdmin.System.Job.View.Error.forbidden
                case .failure, .transport, .conflict:
                    throw WebAdmin.System.Job.View.Error.unavailable
                }
            }
        }
    }
}
