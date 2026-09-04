import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListNewsletterIssuesPresenter: Sendable {
    func render(
        newsletterId: String,
        items: [AdminNewsletterIssueItem],
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
