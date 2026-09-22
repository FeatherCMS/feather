import FeatherAdmin

struct AdminAddRedirectRuleDefaultInteractor: AdminAddRedirectRuleInteractor {
    let repository: any AdminAddRedirectRuleRepository

    func add(
        input: RedirectRuleAddFormInput
    ) async throws {
        do { try await repository.create(input: input) }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .unauthorized: throw AdminAddRedirectRuleError.unauthorized
            case .forbidden: throw AdminAddRedirectRuleError.forbidden
            case .failure(let failure) where failure.statusCode == 409:
                throw AdminAddRedirectRuleError.conflict
            case .conflict: throw AdminAddRedirectRuleError.conflict
            default: throw AdminAddRedirectRuleError.unavailable
            }
        }
    }
}
