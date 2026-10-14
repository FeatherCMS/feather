import FeatherAdmin

protocol AdminRemoveMediaVariantRepository: Sendable {
    func names(ids: [String]) async throws -> [AdminRemoveItemContext]
    func delete(ids: [String]) async throws
}
