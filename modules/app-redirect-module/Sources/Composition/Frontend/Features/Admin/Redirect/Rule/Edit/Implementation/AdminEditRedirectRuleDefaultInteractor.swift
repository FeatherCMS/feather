import FeatherAdmin

struct AdminEditRedirectRuleDefaultInteractor:
    AdminEditRedirectRuleInteractor
{
    let repository: any AdminEditRedirectRuleRepository

    func load(
        id: String
    ) async throws -> RedirectRuleEditModel {
        do { return try await repository.load(id: id) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func update(
        id: String,
        input: RedirectRuleEditFormInput
    ) async throws {
        do { try await repository.update(id: id, input: input) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    private func map(_ error: OpenAPIRepositoryError)
        -> AdminEditRedirectRuleError
    {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .conflict
        case .failure(let failure) where failure.statusCode == 409: .conflict
        default: .unavailable
        }
    }
}
