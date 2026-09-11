import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddNewsletterIssuePresenter: Sendable {
    func renderPage(
        model: AdminAddNewsletterIssueModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
