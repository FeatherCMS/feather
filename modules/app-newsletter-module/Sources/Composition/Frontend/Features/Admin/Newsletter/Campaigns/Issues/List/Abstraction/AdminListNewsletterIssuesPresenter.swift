import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterIssuesPresenter: Sendable {
    func render(
        newsletterId: String,
        model: NewAdminListModel<AdminNewsletterIssueItem>,
        error: String?,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse
}
