protocol AdminRemoveContactFormFieldInteractor: Sendable {
    func get(formId: String, id: String) async throws
        -> AdminContactFormFieldRow
    func remove(formId: String, id: String) async throws
    func bulkRemove(formId: String, ids: [String]) async throws
}
