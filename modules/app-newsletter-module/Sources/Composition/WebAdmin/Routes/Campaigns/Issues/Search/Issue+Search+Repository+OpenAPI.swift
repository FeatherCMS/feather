import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Issue.Search.Repository {
    struct OpenAPI {
        let api: API.Client

        func search(
            newsletterId: String,
            page: Int,
            search: String?
        ) async throws -> AdminListModel<Issue.Search.Item> {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let pageSize = 20
                let request = Components.Schemas
                    .NewsletterIssueQueryItemSearchRequestQuerySchema(
                        page: .init(size: pageSize, number: page),
                        filters: .init(search: search)
                    )
                let response = try await client.newsletterIssueQuery(
                    .init(
                        path: .init(newsletterCampaignKey: newsletterId),
                        body: .json(request)
                    )
                )
                switch response {
                case .ok(let value):
                    let result = try value.body.json
                    var items: [Issue.Search.Item] = []
                    for issue in result.data.items {
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
                    return .init(
                        items: items,
                        pageState: .init(
                            page: page,
                            pageSize: pageSize,
                            total: result.data.total
                        )
                    )
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
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
        ) async throws -> [Issue.Search.DeliveryItem] {
            let response = try await api.withOpenAPIRepositoryErrorMapping {
                client in
                try await client.newsletterIssueDeliveryList(
                    path: .init(
                        newsletterCampaignKey: newsletterId,
                        newsletterIssueId: issueId
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
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
            case .notFound:
                return []
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
