protocol AdminRemoveContactFormInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
    func bulkRemove(ids: [String]) async throws
}
