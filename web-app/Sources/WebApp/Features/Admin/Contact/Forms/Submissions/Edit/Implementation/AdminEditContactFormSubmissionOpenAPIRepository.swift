import AdminOpenAPI

struct AdminEditContactFormSubmissionOpenAPIRepository {
    let api: AdminAPI
    func update(formId: String, id: String, status: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormSubmissionUpdate(
                path: .init(contactFormId: formId, contactFormSubmissionId: id),
                body: .json(.init(status: status))
            )
            switch response {
            case .ok: return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This submission could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to update submissions."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot update submissions."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
