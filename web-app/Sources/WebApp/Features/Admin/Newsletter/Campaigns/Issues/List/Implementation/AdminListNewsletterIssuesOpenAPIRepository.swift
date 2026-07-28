import AdminOpenAPI
import Foundation

struct AdminListNewsletterIssuesOpenAPIRepository {
    let api: AdminAPI

    func list(newsletterId: String) async throws
        -> [AdminNewsletterIssueItem]
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterIssueList(
                path: .init(contactNewsletterId: newsletterId)
            )
            switch response {
            case .ok(let value):
                var items: [AdminNewsletterIssueItem] = []
                for issue in try value.body.json {
                    let deliveries = try await self.deliveries(
                        newsletterId: newsletterId,
                        issueId: issue.id,
                        subject: issue.subject
                    )
                    items.append(
                        .init(
                            id: issue.id,
                            subject: issue.subject,
                            status: issue.status,
                            scheduledAt: issue.scheduledAt.map {
                                DateFormatting.formatUnixTimestamp($0)
                            } ?? "—",
                            createdAt: DateFormatting.formatUnixTimestamp(
                                issue.createdAt
                            ),
                            deliveries: deliveries
                        )
                    )
                }
                return items
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

    private func deliveries(
        newsletterId: String,
        issueId: String,
        subject: String
    ) async throws -> [AdminNewsletterIssueDeliveryItem] {
        let response = try await api.withOpenAPIRepositoryErrorMapping {
            client in
            try await client.contactNewsletterIssueDeliveryList(
                path: .init(
                    contactNewsletterId: newsletterId,
                    contactNewsletterIssueId: issueId
                )
            )
        }
        switch response {
        case .ok(let value):
            return try value.body.json.map {
                .init(
                    issueSubject: subject,
                    subscriberEmail: $0.subscriberEmail,
                    status: $0.status,
                    sentAt: $0.sentAt.map {
                        DateFormatting.formatUnixTimestamp($0)
                    } ?? "—",
                    failureReason: $0.failureReason ?? "—"
                )
            }
        case .unauthorized:
            throw OpenAPIRepositoryError.unauthorized(
                message: "Please sign in again to view delivery statuses."
            )
        case .forbidden:
            throw OpenAPIRepositoryError.forbidden(
                message: "Your account cannot view delivery statuses."
            )
        case .notFound: return []
        case .undocumented(let statusCode, let response):
            throw try await api.failure(
                statusCode: statusCode,
                responseBody: response.body
            )
        }
    }
}
