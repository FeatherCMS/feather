protocol AdminViewContactFormSubmissionInteractor: Sendable {
    func get(formId: String, id: String) async throws
        -> AdminContactFormSubmissionItem
}
