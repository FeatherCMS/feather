import FeatherAdmin
import NewsletterAdminAPI
import OpenAPIRuntime

struct AdminNewsletterCampaignAPIClient {
    let api: NewsletterAdminAPIClient

    func list() async throws -> [AdminNewsletterCampaignItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterCampaignList()
            switch response {
            case .ok(let value):
                return try value.body.json.map {
                    .init(id: $0.key, name: $0.name, fromEmail: $0.fromEmail)
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

    func get(id: String) async throws -> AdminNewsletterCampaignItem {
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
    ) async throws -> AdminNewsletterCampaignItem {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterCampaignUpdate(
                path: .init(newsletterCampaignKey: id),
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
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }

    func remove(ids: [String]) async throws {
        for id in ids {
            try await remove(id: id)
        }
    }
}
