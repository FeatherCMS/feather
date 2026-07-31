protocol AdminRemoveContactFormEmailInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
    func bulkRemove(id: String, emailIds: [String]) async throws
}
