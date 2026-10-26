import FeatherWebAdmin
import FeatherWebShared
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime

extension Campaign.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func createNewsletter(
            key: String,
            name: String,
            fromEmail: String
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsletterCampaignCreate(
                    body: .json(
                        .init(key: key, name: name, fromEmail: fromEmail)
                    )
                )
                switch response {
                case .created:
                    return
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
