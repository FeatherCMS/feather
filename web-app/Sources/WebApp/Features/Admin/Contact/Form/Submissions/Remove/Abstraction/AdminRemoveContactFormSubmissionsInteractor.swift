protocol AdminRemoveContactFormSubmissionsInteractor: Sendable {
    func get(formId: String, id: String) async throws
        -> AdminContactFormSubmissionItem
    func remove(formId: String, id: String) async throws
    func bulkRemove(formId: String, ids: [String]) async throws
}
