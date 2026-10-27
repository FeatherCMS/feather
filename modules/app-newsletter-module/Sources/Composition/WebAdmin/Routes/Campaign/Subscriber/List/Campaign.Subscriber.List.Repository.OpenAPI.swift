import FeatherWebAdmin
import FeatherWebShared
import Foundation
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime

extension Campaign.Subscriber.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func search(
            newsletterId: String,
            search: String?,
            page: Int
        ) async throws -> Campaign.Subscriber.List.Result {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let campaignResponse = try await client.newsletterCampaignGet(
                    path: .init(newsletterCampaignId: newsletterId)
                )
                let campaignKey: String
                switch campaignResponse {
                case .ok(let value):
                    campaignKey = try value.body.json.key
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }

                let response = try await client.newsletterSubscriberQuery(
                    body: .json(
                        .init(
                            page: .init(size: 20, number: page),
                            sort: [.init(field: .email, direction: .asc)],
                            filters: .init(
                                search: search,
                                campaignKey: campaignKey
                            )
                        )
                    )
                )
                switch response {
                case .ok(let value):
                    let result = try value.body.json
                    let items: [Campaign.Subscriber.List.Item] =
                        result.data.items.compactMap { item in
                            guard
                                let membership = item.memberships.first(where: {
                                    $0.campaignKey == campaignKey
                                })
                            else {
                                return nil
                            }
                            return Campaign.Subscriber.List.Item(
                                id: Data(item.email.utf8)
                                    .base64EncodedString()
                                    .replacingOccurrences(of: "+", with: "-")
                                    .replacingOccurrences(of: "/", with: "_")
                                    .replacingOccurrences(of: "=", with: ""),
                                email: item.email,
                                name: item.name,
                                status: membership.status,
                                subscriptionDate:
                                    DateFormatting.formatUnixTimestamp(
                                        membership.subscriptionDate
                                    ),
                                unsubscriptionDate:
                                    membership.unsubscriptionDate.map {
                                        DateFormatting
                                            .formatUnixTimestamp($0)
                                    } ?? "—"
                            )
                        }
                    return .init(items: items, total: result.data.total)
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
    }
}
