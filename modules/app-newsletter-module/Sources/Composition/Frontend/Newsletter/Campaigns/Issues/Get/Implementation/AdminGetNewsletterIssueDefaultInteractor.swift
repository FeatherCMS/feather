import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetNewsletterIssueDefaultInteractor:
    AdminGetNewsletterIssueInteractor
{
    let repository: AdminGetNewsletterIssueOpenAPIRepository
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
    { try await repository.get(newsletterId: newsletterId, issueId: issueId) }
}
