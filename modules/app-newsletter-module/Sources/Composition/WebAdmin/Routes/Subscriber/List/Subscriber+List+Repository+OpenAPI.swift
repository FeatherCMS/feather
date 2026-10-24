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

        func get(id: String) async throws -> Subscriber.List.Model.Item {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let newslettersResponse =
                    try await client.newsletterCampaignList()
                guard case .ok(let newslettersValue) = newslettersResponse
                else {
                    throw OpenAPIRepositoryError.forbidden
                }
                var grouped: [String: Subscriber.List.Model.Item] = [:]
                for newsletter in try newslettersValue.body.json {
                    let response = try await client.newsletterSubscriberList(
                        path: .init(newsletterCampaignKey: newsletter.key)
                    )
                    guard case .ok(let value) = response else { continue }
                    for subscriber in try value.body.json {
                        let firstName = subscriber.firstName ?? ""
                        let lastName = subscriber.lastName ?? ""
                        let current =
                            grouped[subscriber.id]
                            ?? .init(
                                id: subscriber.id,
                                email: subscriber.email,
                                name: "\(firstName) \(lastName)"
                                    .whitespaceTrimmed,
                                newsletters: []
                            )
                        grouped[subscriber.id] = .init(
                            id: current.id,
                            email: current.email,
                            name: current.name.isEmpty
                                ? subscriber.email : current.name,
                            newsletters: current.newsletters + [
                                .init(
                                    id: newsletter.key,
                                    name: newsletter.name,
                                    status: subscriber.status
                                )
                            ]
                        )
                    }
                }
                guard let item = grouped.values.first(where: { $0.id == id })
                else {
                    throw OpenAPIRepositoryError.notFound
                }
                return item
            }
        }
    }
}
