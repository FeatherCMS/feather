import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime

extension Subscriber.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func campaigns() async throws -> [Subscriber.List.Model.Campaign] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterCampaignList()
                switch response {
                case .ok(let value):
                    return try value.body.json.map {
                        .init(id: $0.key, name: $0.name)
                    }
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

        func search(
            search: String?,
            campaignKey: String?,
            page: Int
        ) async throws -> SearchResult {
            try await api.withOpenAPIRepositoryErrorMapping { client in
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
                    return .init(
                        items: result.data.items.map { item in
                            .init(
                                id: Data(item.email.utf8)
                                    .base64EncodedString()
                                    .replacingOccurrences(of: "+", with: "-")
                                    .replacingOccurrences(of: "/", with: "_")
                                    .replacingOccurrences(of: "=", with: ""),
                                email: item.email,
                                name: item.name,
                                newsletters: item.memberships.map {
                                    .init(
                                        id: $0.campaignKey,
                                        name: $0.campaignName,
                                        status: $0.status
                                    )
                                }
                            )
                        },
                        total: result.data.total
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

    }
}
