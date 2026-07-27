import AdminOpenAPI

struct AdminAddContactFormEmailOpenAPIRepository {
    let api: AdminAPI
    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await AdminGetContactFormOpenAPIRepository(api: api).get(id: id)
    }
    func update(
        id: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws -> AdminContactFormDetailsItem {
        try await AdminEditContactFormOpenAPIRepository(api: api)
            .update(
                id: id,
                name: name,
                successMessage: successMessage,
                failureMessage: failureMessage,
                redirectUrl: redirectUrl,
                fieldIDs: fieldIDs,
                mails: mails
            )
    }
}
