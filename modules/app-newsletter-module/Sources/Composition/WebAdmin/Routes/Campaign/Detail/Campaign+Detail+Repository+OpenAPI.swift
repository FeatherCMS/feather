import FeatherWebAdmin
import FeatherWebShared
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime

extension Campaign.Detail.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

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
    }
}
