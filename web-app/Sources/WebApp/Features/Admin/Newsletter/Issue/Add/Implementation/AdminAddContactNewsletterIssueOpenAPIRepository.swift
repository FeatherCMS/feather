import AdminOpenAPI

struct AdminAddContactNewsletterIssueOpenAPIRepository {
    let api: AdminAPI
    func createIssue(newsletterId: String, form: ContactNewsletterIssueAddForm) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterIssueCreate(path: .init(contactNewsletterId: newsletterId), body: .json(.init(subject: form.normalizedSubject, content: form.content)))
            switch response {
            case .created: return
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to create a newsletter issue.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot create newsletter issues.")
            case let .undocumented(statusCode, response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }
}
