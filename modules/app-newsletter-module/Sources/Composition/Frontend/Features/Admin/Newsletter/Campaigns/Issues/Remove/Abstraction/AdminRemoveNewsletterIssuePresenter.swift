import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterIssuePresenter: Sendable {
    func render(newsletterId: String, item: AdminRemoveItemContext)
        async throws -> HTMLResponse
}
