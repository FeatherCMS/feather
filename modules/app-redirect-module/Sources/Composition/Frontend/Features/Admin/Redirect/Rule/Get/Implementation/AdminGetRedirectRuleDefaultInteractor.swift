import FeatherAdmin
import Foundation

struct AdminGetRedirectRuleDefaultInteractor: AdminGetRedirectRuleInteractor {
    let repository: any AdminGetRedirectRuleRepository

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel {
        do { return try await repository.load(id: id) }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .notFound: throw AdminGetRedirectRuleError.notFound
            case .unauthorized: throw AdminGetRedirectRuleError.unauthorized
            case .forbidden: throw AdminGetRedirectRuleError.forbidden
            default: throw AdminGetRedirectRuleError.unavailable
            }
        }
    }
}
