import RedirectModule
import FeatherWebAdmin
import RedirectApplication

extension RedirectModule.Rule.View.Interactor {
    struct Default: Interface {
    let repository: any RedirectModule.Rule.View.Repository.Interface

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel {
        do { return try await repository.load(id: id) }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .notFound: throw RedirectModule.Rule.View.Error.notFound
            case .unauthorized: throw RedirectModule.Rule.View.Error.unauthorized
            case .forbidden: throw RedirectModule.Rule.View.Error.forbidden
            default: throw RedirectModule.Rule.View.Error.unavailable
            }
        }
    }
}
}
