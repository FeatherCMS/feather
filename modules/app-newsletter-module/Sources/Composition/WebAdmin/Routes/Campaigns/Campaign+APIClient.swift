import FeatherWebAdmin
import FeatherWebShared
import Foundation
import NewsletterAdminAPI
import NewsletterModule
import OpenAPIRuntime

extension Campaign {
    struct APIClient {
        let api: API.Client

        func search(
            page: Int,
            search: String?
        ) async throws -> Campaign.Search.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterCampaignQuery(
                    body: .json(
                        .init(
                            page: .init(size: 20, number: page),
                            filters: .init(search: search)
                        )
                    )
                )
                switch response {
                case .ok(let value):
                    let body = try value.body.json
                    return .init(
                        items: body.data.items.map {
                            .init(
                                id: $0.key,
                                name: $0.name,
                                fromEmail: $0.fromEmail
                            )
                        },
                        pageState: .init(
                            page: body.query.page.number,
                            pageSize: body.query.page.size,
                            total: body.data.total
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

        func get(id: String) async throws -> Campaign.Item {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterCampaignGet(
                    path: .init(newsletterCampaignKey: id)
                )
                switch response {
                case .ok(let value):
                    let item = try value.body.json
                    return .init(
                        id: item.key,
                        name: item.name,
                        fromEmail: item.fromEmail
                    )
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
            }
        }

        func update(
            id: String,
            newKey: String,
            name: String,
            fromEmail: String
        ) async throws -> Campaign.Item {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterCampaignUpdate(
                    path: .init(newsletterCampaignKey: id),
                    query: .init(updateMask: "key,name,fromEmail"),
                    body: .json(
                        .init(key: newKey, name: name, fromEmail: fromEmail)
                    )
                )
                switch response {
                case .ok(let value):
                    let item = try value.body.json
                    return .init(
                        id: item.key,
                        name: item.name,
                        fromEmail: item.fromEmail
                    )
                case .badRequest(let response):
                    let data = try JSONEncoder().encode(
                        try response.body.json
                    )
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
                    )
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
            }
        }

        func remove(id: String) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.newsletterCampaignRemove(
                    body: .json(.init(ids: [id]))
                )
            }
        }

        func remove(ids: [String]) async throws {
            for id in ids {
                try await remove(id: id)
            }
        }
    }
}
