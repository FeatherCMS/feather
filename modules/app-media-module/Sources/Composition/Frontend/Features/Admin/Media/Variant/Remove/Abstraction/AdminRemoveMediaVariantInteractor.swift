import FeatherWebAdmin

protocol AdminRemoveMediaVariantInteractor: Sendable {

    func delete(ids: [String]) async throws
}
