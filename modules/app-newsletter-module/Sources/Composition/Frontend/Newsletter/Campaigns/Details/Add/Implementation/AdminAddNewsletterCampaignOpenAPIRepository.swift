import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterCampaignOpenAPIRepository {
    let api: NewsletterAdminAPIClient

    func createNewsletter(
        name: String,
        fromEmail: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterCampaignCreate(
                body: .json(.init(name: name, fromEmail: fromEmail))
            )
            switch response {
            case .created: return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to create a newsletter."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create newsletters."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
