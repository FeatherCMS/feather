import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterIssuesInteractor: Sendable {
    func list(
        newsletterId: String,
        page: Int,
        search: String?
    ) async throws -> NewAdminListModel<AdminNewsletterIssueItem>
}
