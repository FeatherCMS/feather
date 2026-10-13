import FeatherAdmin

struct AdminRemoveRedirectRuleDefaultInteractor:
    AdminRemoveRedirectRuleInteractor
{
    let repository: any AdminRemoveRedirectRuleRepository

    func names(ids: [String]) async throws -> [String] {
        do { return try await repository.names(ids: ids) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func delete(ids: [String]) async throws {
        do { try await repository.delete(ids: ids) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    private func map(_ error: OpenAPIRepositoryError)
        -> AdminRemoveRedirectRuleError
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
