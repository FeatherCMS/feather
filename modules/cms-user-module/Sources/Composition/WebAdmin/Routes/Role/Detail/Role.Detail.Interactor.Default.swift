import FeatherWebAdmin
import FeatherWebShared
import UserModule

extension Role.Detail.Interactor {
    struct Default: Interface {
        let repository: any Role.Detail.Repository.Interface

        func load(
            id: String
        ) async throws -> Role.Detail.Repository.Model {
            do { return try await repository.load(id: id) }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .notFound: throw Role.Detail.Error.notFound
                case .unauthorized: throw Role.Detail.Error.unauthorized
                case .forbidden: throw Role.Detail.Error.forbidden
                default: throw Role.Detail.Error.unavailable
                }
            }
        }
    }
}
