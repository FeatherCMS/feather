struct AdminAddContactFormDefaultInteractor: AdminAddContactFormInteractor {
    let repository: AdminAddContactFormOpenAPIRepository

    func create(
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws {
        _ = try await repository.create(
            name: name,
            successMessage: successMessage,
            failureMessage: failureMessage,
            redirectUrl: redirectUrl,
            fieldIDs: fieldIDs,
            mails: mails
        )
    }
}
