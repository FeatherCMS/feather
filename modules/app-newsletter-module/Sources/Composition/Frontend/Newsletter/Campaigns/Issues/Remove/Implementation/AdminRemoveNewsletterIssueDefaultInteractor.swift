import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterIssueDefaultInteractor:
    AdminRemoveNewsletterIssueInteractor
{
    let repository: AdminRemoveNewsletterIssueOpenAPIRepository
    func remove(newsletterId: String, issueId: String) async throws {
        try await repository.remove(
            newsletterId: newsletterId,
            issueId: issueId
        )
    }
}
