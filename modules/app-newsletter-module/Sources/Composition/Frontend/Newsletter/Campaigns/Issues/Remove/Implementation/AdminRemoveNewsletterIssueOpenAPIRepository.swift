import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveNewsletterIssueOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func remove(newsletterId: String, issueId: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterIssueDelete(
                path: .init(
                    newsletterCampaignId: newsletterId,
                    newsletterIssueId: issueId
                )
            )
            switch response {
            case .noContent: return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This campaign issue could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to delete campaign issues."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete campaign issues."
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
