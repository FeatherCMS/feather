import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditNewsletterIssuePresenter: Sendable {
    func render(
        model: AdminAddNewsletterIssueModel,
        issueId: String?,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse
}
