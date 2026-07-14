protocol AdminManageContactFormSubmissionsInteractor: Sendable {
    func list(formId: String) async throws -> [AdminManageContactFormSubmissionRow]
    func get(formId: String, id: String) async throws -> AdminManageContactFormSubmissionRow
    func update(formId: String, id: String, status: String) async throws
    func remove(formId: String, id: String) async throws
    func bulkRemove(formId: String, ids: [String]) async throws
}
