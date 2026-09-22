import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterCampaignOpenAPIRepository {
    let api: NewsletterAdminAPIClient

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
            case .created: return
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
