protocol AdminRemoveContactFieldInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFieldRow
    func remove(id: String) async throws
    func bulkRemove(ids: [String]) async throws
}
