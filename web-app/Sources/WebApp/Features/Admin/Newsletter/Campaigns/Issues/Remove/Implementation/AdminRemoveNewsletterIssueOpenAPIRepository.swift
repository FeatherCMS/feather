import AdminOpenAPI

struct AdminRemoveNewsletterIssueOpenAPIRepository {
    let api: AdminAPI
    func remove(newsletterId: String, issueId: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterIssueDelete(
                path: .init(
                    contactNewsletterId: newsletterId,
                    contactNewsletterIssueId: issueId
                )
            )
            switch response {
            case .noContent: return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This campaign issue could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to delete campaign issues."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete campaign issues."
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
