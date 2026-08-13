import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddNewsletterIssuePresenter: Sendable {
    func renderPage(
        model: AdminAddNewsletterIssueModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
