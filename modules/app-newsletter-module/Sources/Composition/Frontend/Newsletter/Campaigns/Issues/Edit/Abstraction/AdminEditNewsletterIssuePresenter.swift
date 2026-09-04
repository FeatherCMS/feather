import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditNewsletterIssuePresenter: Sendable {
    func render(
        model: AdminAddNewsletterIssueModel,
        issueId: String?,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse
}
