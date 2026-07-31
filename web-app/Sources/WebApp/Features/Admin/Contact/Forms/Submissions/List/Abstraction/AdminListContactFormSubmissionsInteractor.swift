protocol AdminListContactFormSubmissionsInteractor: Sendable {
    func list(formId: String) async throws -> [AdminContactFormSubmissionItem]
}
