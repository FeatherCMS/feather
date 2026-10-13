import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminViewNewsletterIssuePresenter: Sendable {
    func render(
        model: AdminAddNewsletterIssueModel,
        issueId: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
