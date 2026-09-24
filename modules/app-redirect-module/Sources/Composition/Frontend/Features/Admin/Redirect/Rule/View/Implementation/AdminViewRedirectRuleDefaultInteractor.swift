import FeatherAdmin

struct AdminViewRedirectRuleDefaultInteractor: AdminViewRedirectRuleInteractor {
    let repository: any AdminViewRedirectRuleRepository

    func load(
        id: String
    ) async throws -> RedirectRuleDetailsModel {
        do { return try await repository.load(id: id) }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .notFound: throw AdminViewRedirectRuleError.notFound
            case .unauthorized: throw AdminViewRedirectRuleError.unauthorized
            case .forbidden: throw AdminViewRedirectRuleError.forbidden
            default: throw AdminViewRedirectRuleError.unavailable
            }
        }
    }
}
