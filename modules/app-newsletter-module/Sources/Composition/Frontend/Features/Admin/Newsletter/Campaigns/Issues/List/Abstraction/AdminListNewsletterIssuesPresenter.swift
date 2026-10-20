import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterIssuesPresenter: Sendable {
    func render(
        newsletterId: String,
        model: AdminListModel<AdminNewsletterIssueItem>,
        error: String?,
        permissions: AdminListActions,
        search: String?
    ) async throws -> HTMLResponse
}
