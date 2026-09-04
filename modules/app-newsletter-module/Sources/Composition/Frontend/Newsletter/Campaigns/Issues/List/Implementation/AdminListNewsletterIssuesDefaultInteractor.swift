import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

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
