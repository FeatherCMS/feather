import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterIssuesDefaultInteractor:
    AdminListNewsletterIssuesInteractor
{
    let repository: AdminListNewsletterIssuesOpenAPIRepository

    func list(newsletterId: String) async throws
        -> [AdminNewsletterIssueItem]
    {
        try await repository.list(newsletterId: newsletterId)
    }
}
