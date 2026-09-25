import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterIssueOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
    {
        try await AdminEditNewsletterIssueOpenAPIRepository(api: api)
            .get(
                newsletterId: newsletterId,
                issueId: issueId
            )
    }
    func remove(newsletterId: String, issueId: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.newsletterIssueRemove(
                path: .init(newsletterCampaignKey: newsletterId),
                body: .json(
                    .init(ids: [issueId], results: false, summary: true)
                )
            )
            switch response {
            case .ok(let value):
                guard try value.body.json.summary?.deleted == 1 else {
                    throw OpenAPIRepositoryError.notFound
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
}
