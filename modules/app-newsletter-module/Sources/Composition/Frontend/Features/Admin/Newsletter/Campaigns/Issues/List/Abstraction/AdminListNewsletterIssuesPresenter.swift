import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterIssuesPresenter: Sendable {
    func render(
        newsletterId: String,
        items: [AdminNewsletterIssueItem],
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
