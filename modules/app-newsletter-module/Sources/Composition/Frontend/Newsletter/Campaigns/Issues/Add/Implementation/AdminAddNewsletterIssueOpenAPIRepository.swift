import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterIssueOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func createIssue(newsletterId: String, form: NewsletterIssueAddForm)
        async throws
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterIssueCreate(
                path: .init(newsletterCampaignId: newsletterId),
                body: .json(
                    .init(
                        subject: form.normalizedSubject,
                        content: form.content
                    )
                )
            )
            switch response {
            case .created: return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to create a newsletter issue."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create newsletter issues."
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
