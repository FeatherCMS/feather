import FeatherWebAdmin
import FeatherWebShared
import SystemModule

extension Job.View.Interactor {
    struct Default: Interface {
        let repository: any Job.View.Repository.Interface

        func execute(entity: Job.View.Model)
            async throws
            -> Job.View.Result
        {
            do {
                return try await repository.get(id: entity.id)
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .notFound:
                    throw Job.View.Error.notFound
                case .unauthorized:
                    throw Job.View.Error
                        .unauthorized
                case .forbidden:
                    throw Job.View.Error.forbidden
                case .failure, .transport, .conflict:
                    throw Job.View.Error
                        .unavailable
                }
            }
        }
    }
}
