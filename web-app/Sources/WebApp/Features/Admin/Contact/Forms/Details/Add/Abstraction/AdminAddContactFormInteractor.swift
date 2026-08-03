protocol AdminAddContactFormInteractor: Sendable {
    func availableFields() async throws -> [AdminContactFormFieldOption]
    func create(
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws
}
