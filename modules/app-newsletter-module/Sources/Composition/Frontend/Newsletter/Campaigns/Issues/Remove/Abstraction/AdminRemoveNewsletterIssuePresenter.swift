import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveNewsletterIssuePresenter: Sendable {
    func render(newsletterId: String, issueId: String, permissions: Set<String>)
        -> HTMLResponse
}
