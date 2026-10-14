import FeatherAdmin

protocol AdminRemoveMediaVariantInteractor: Sendable {

    func delete(ids: [String]) async throws
}
