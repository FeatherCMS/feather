import FeatherWebAdmin
import FeatherWebShared
import RedirectApplication
import RedirectModule

extension Rule.View.Interactor {
    struct Default: Interface {
        let repository: any Rule.View.Repository.Interface

        func load(
            id: String
        ) async throws -> Rule.View.Model {
            do { return try await repository.load(id: id) }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .notFound: throw Rule.View.Error.notFound
                case .unauthorized: throw Rule.View.Error.unauthorized
                case .forbidden: throw Rule.View.Error.forbidden
                default: throw Rule.View.Error.unavailable
                }
            }
        }
    }
}
