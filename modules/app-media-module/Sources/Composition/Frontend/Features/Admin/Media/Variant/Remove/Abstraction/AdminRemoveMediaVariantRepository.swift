import FeatherAdmin

protocol AdminRemoveMediaVariantRepository: Sendable {
    func names(ids: [String]) async throws -> [NewAdminRemoveItemContext]
    func delete(ids: [String]) async throws
}
