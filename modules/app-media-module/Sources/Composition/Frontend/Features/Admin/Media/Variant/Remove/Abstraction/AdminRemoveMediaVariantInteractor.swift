import FeatherAdmin

protocol AdminRemoveMediaVariantInteractor: Sendable {
    func names(ids: [String]) async throws -> [NewAdminRemoveItemContext]
    func delete(ids: [String]) async throws
}
