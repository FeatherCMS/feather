protocol AdminEditContactFormSubmissionInteractor: Sendable {
    func update(formId: String, id: String, status: String) async throws
}
