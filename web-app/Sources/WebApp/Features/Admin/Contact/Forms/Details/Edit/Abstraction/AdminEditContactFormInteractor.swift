protocol AdminEditContactFormInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
    func update(
        id: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws
}
