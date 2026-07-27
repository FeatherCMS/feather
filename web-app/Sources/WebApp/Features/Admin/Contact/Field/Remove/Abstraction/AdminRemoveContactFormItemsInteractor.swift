protocol AdminRemoveContactFormItemsInteractor: Sendable {
    func get(formId: String, id: String) async throws -> AdminContactFormItemRow
    func remove(formId: String, id: String) async throws
    func bulkRemove(formId: String, ids: [String]) async throws
}
