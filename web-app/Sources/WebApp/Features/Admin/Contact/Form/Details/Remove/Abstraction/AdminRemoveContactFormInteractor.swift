protocol AdminRemoveContactFormInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
    func remove(id: String) async throws
    func bulkRemove(ids: [String]) async throws
}
