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
    func get(newsletterId: String, issueId: String) async throws
        -> NewAdminRemoveItemContext
    {
        let issue = try await repository.get(
            newsletterId: newsletterId,
            issueId: issueId
        )
        return .init(id: issueId, label: issue.subject)
    }
    func remove(newsletterId: String, issueId: String) async throws {
        try await repository.remove(
            newsletterId: newsletterId,
            issueId: issueId
        )
    }
}
