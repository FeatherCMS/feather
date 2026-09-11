import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminGetNewsletterIssuePresenter: Sendable {
    func render(
        model: AdminAddNewsletterIssueModel,
        issueId: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
