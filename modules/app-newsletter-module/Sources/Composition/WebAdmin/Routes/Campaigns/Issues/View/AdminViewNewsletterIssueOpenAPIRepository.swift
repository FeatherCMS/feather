import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterIssueOpenAPIRepository {
    let api: API.Client
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
    {
        try await AdminEditNewsletterIssueOpenAPIRepository(api: api)
            .get(newsletterId: newsletterId, issueId: issueId)
    }
}
