import FeatherAdmin

struct AdminRemoveMediaVariantDefaultInteractor: AdminRemoveMediaVariantInteractor {
    let repository: any AdminRemoveMediaVariantRepository

    func names(ids: [String]) async throws -> [NewAdminRemoveItemContext] {
        do { return try await repository.names(ids: ids) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func delete(ids: [String]) async throws {
        do { try await repository.delete(ids: ids) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    private func map(_ error: OpenAPIRepositoryError) -> AdminRemoveMediaVariantError {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .unavailable
        case .failure, .transport: .unavailable
        }
    }
}
