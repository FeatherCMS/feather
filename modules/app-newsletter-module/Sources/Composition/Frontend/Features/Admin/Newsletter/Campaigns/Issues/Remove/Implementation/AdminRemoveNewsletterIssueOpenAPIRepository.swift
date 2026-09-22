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
        try await AdminEditNewsletterIssueOpenAPIRepository(api: api).get(
            newsletterId: newsletterId,
            issueId: issueId
        )
    }
    func remove(newsletterId: String, issueId: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.newsletterIssueRemove(
                path: .init(newsletterCampaignKey: newsletterId),
                body: .json(
                    .init(ids: [issueId], results: false, summary: true)
                )
            )
        }
    }
}
