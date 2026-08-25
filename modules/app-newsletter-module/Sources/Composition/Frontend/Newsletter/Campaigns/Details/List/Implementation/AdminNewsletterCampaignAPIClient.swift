import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminNewsletterCampaignAPIClient {
    let api: NewsletterAdminAPIClient

    func list() async throws -> [AdminNewsletterCampaignItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterCampaignList()
            switch response {
            case .ok(let value):
                return try value.body.json.map {
                    .init(id: $0.id, name: $0.name, fromEmail: $0.fromEmail)
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view newsletters."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view newsletters."
                )
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
                path: .init(newsletterCampaignId: id)
            )
            switch response {
            case .ok(let value):
                let item = try value.body.json
                return .init(
                    id: item.id,
                    name: item.name,
                    fromEmail: item.fromEmail
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view this newsletter."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view this newsletter."
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This newsletter could not be found."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func update(id: String, name: String, fromEmail: String) async throws
        -> AdminNewsletterCampaignItem
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterCampaignUpdate(
                path: .init(newsletterCampaignId: id),
                body: .json(.init(name: name, fromEmail: fromEmail))
            )
            switch response {
            case .ok(let value):
                let item = try value.body.json
                return .init(
                    id: item.id,
                    name: item.name,
                    fromEmail: item.fromEmail
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to edit newsletters."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit newsletters."
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This newsletter could not be found."
                )
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
            _ = try await client.newsletterCampaignBulkDelete(body: .json(.init(ids: [id], summary: true)))
        }
    }

    func bulkRemove(ids: [String]) async throws {
        for id in ids {
            try await remove(id: id)
        }
    }
}
