import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterIssuePresenter: Sendable {
    func render(newsletterId: String, issueId: String, permissions: Set<String>)
        -> HTMLResponse
}
