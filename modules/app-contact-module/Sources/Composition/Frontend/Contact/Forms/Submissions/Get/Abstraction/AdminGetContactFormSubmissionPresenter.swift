import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminGetContactFormSubmissionPresenter: Sendable {
    func renderPage(
        formId: String,
        item: AdminContactFormSubmissionItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
