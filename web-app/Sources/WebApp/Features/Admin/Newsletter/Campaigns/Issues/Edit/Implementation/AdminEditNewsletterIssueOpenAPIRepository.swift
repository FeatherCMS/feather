import AdminOpenAPI

struct AdminEditNewsletterIssueOpenAPIRepository {
    let api: AdminAPI
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterIssueGet(
                path: .init(
                    contactNewsletterId: newsletterId,
                    contactNewsletterIssueId: issueId
                )
            )
            switch response {
            case .ok(let value):
                let issue = try value.body.json
                return .init(
                    subject: issue.subject,
                    content: issue.content,
                    scheduledAt: issue.scheduledAt.map {
                        String(describing: $0)
                    } ?? "",
                    newsletterId: newsletterId,
                    error: nil
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This campaign issue could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view campaign issues."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view campaign issues."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
    func update(
        newsletterId: String,
        issueId: String,
        form: NewsletterIssueAddForm
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterIssueUpdate(
                path: .init(
                    contactNewsletterId: newsletterId,
                    contactNewsletterIssueId: issueId
                ),
                body: .json(
                    .init(
                        subject: form.normalizedSubject,
                        content: form.content,
                        scheduledAt: Double(form.scheduledAt)
                    )
                )
            )
            switch response {
            case .ok: return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This campaign issue could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to edit campaign issues."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit campaign issues."
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
