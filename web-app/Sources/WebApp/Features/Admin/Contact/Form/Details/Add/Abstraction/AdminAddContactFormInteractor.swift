protocol AdminAddContactFormInteractor: Sendable {
    func create(
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws
}
