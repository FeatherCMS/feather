import AdminOpenAPI

struct AdminNewsletterIssueListOpenAPIRepository {
    let api: AdminAPI

    func list(newsletterId: String) async throws -> [AdminNewsletterIssueListItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterIssueList(path: .init(contactNewsletterId: newsletterId))
            switch response {
            case .ok(let value):
                return try value.body.json.map {
                    .init(id: $0.id, subject: $0.subject, status: $0.status, scheduledAt: $0.scheduledAt.map { String($0) } ?? "—", createdAt: String($0.createdAt))
                }
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to view campaign issues.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view campaign issues.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }
}
