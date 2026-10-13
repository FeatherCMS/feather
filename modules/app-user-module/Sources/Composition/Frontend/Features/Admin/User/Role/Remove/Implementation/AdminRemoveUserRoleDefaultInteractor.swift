import FeatherAdmin

struct AdminRemoveUserRoleDefaultInteractor: AdminRemoveUserRoleInteractor {
    let repository: any AdminRemoveUserRoleRepository

    func names(
        ids: [String]
    ) async throws -> [String] {
        do { return try await repository.names(ids: ids) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func delete(
        ids: [String]
    ) async throws {
        do { try await repository.delete(ids: ids) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    private func map(_ error: OpenAPIRepositoryError)
        -> AdminRemoveUserRoleError
    {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .conflict
        default: .unavailable
        }
    }
}
