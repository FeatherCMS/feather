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
            _ = try await client.newsletterIssueDelete(
                path: .init(newsletterCampaignId: newsletterId),
                body: .json(
                    .init(ids: [issueId], results: false, summary: true)
                )
            )
        }
    }
}
