import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetNewsletterIssueOpenAPIRepository {
    let api: NewsletterAdminAPIClient
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
    {
        try await AdminEditNewsletterIssueOpenAPIRepository(api: api)
            .get(newsletterId: newsletterId, issueId: issueId)
    }
}
