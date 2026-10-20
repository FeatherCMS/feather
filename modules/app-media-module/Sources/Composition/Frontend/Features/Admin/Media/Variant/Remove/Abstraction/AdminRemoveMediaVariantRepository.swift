import FeatherWebAdmin

protocol AdminRemoveMediaVariantRepository: Sendable {

    func delete(ids: [String]) async throws
}
